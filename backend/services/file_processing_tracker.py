
import logging
from datetime import datetime
import psycopg2

logger = logging.getLogger(__name__)

class FileProcessingTracker:
    def __init__(self, db_connection):
        self.conn = db_connection

    def should_process(self, filename, file_hash=None):
        """
        Check if file should be processed.
        Returns True if:
        1. File never processed
        2. Previous processing failed
        3. File hash changed (if hash provided)
        4. Processing stuck (started > 2 hours ago but not completed)
        """
        cur = self.conn.cursor()
        try:
            cur.execute("""
                SELECT id, status, file_hash, processing_completed_at, processing_started_at
                FROM file_processing_log
                WHERE filename = %s
                ORDER BY id DESC LIMIT 1
            """, (filename,))
            
            result = cur.fetchone()
            
            if not result:
                logger.info(f"File {filename} is new - processing")
                return True
            
            log_id, status, db_hash, completed_at, started_at = result
            
            # Case 1: Already successfully completed
            if status == 'completed':
                # Check hash if provided
                if file_hash and db_hash and file_hash != db_hash:
                    logger.info(f"File {filename} changed (hash mismatch) - reprocessing")
                    return True
                
                logger.debug(f"File {filename} already processed successfully")
                return False
            
            # Case 2: Failed previously
            if status == 'failed':
                logger.info(f"File {filename} failed previously - retrying")
                return True
                
            # Case 3: Stuck in processing
            if status in ('processing', 'downloading', 'extracting', 'parsing', 'importing'):
                if started_at:
                    hours_stuck = (datetime.now() - started_at).total_seconds() / 3600
                    if hours_stuck > 2:
                        logger.warning(f"File {filename} stuck in status '{status}' for {hours_stuck:.1f} hours - retrying")
                        return True
                    else:
                        logger.info(f"File {filename} currently processing (started {started_at}) - skipping parallel process")
                        return False
            
            return True
            
        except Exception as e:
            logger.error(f"Error checking file status: {e}")
            return True # Default to process on error
        finally:
            cur.close()

    def should_process_store_today(self, filename, source_id):
        """
        One-Pass Daily: Check if a store branch has already successfully processed today.
        Prevents redundant processing of the same store from multiple files or re-runs.
        
        Regex matches typical Israeli format: PriceFull7290...-<StoreId>-2025...
        """
        import re
        
        # Try to extract store ID (3 digits usually)
        # Matches: PriceFull7290027600007-065-202512270300.gz -> '065'
        match = re.search(r'[-_](\d{3})[-_]\d{8}', filename)
        if not match:
            return True # Can't identify store, so process it to be safe
            
        store_id = match.group(1)
        today_pattern = datetime.now().strftime("%Y%m%d")
        
        # Look for ANY completed file for this store today
        cur = self.conn.cursor()
        try:
            # Query log for similar filename pattern (same store, same chain)
            # Assumption: Filename structure is consistent for the chain
            # We look for %-STOREID-TODAY%
            like_pattern = f"%-{store_id}-{today_pattern}%"
            
            cur.execute("""
                SELECT 1 FROM file_processing_log 
                WHERE source = %s 
                AND filename LIKE %s 
                AND status = 'completed'
                LIMIT 1
            """, (source_id, like_pattern))
            
            if cur.fetchone():
                logger.info(f"🚫 Skipping {filename}: Store {store_id} already processed successfully today.")
                return False # Do NOT process
            
            return True # Process
            
        except Exception as e:
            logger.error(f"Error checking store daily limit: {e}")
            return True
        finally:
            cur.close()

    def start_processing(self, filename, source, file_hash=None, worker_id=None):
        """Mark file processing started"""
        cur = self.conn.cursor()
        try:
            cur.execute("""
                INSERT INTO file_processing_log 
                (filename, source, file_hash, worker_id, download_started_at, processing_started_at, status)
                VALUES (%s, %s, %s, %s, NOW(), NOW(), 'downloading')
                ON CONFLICT (filename) DO UPDATE SET
                    status = 'downloading',
                    download_started_at = NOW(),
                    processing_started_at = NOW(),
                    processing_completed_at = NULL,
                    error_message = NULL,
                    worker_id = EXCLUDED.worker_id,
                    updated_at = NOW()
                RETURNING id
            """, (filename, source, file_hash, worker_id))
            
            log_id = cur.fetchone()[0]
            self.conn.commit()
            return log_id
        except Exception as e:
            logger.error(f"Error starting processing log: {e}")
            self.conn.rollback()
            return None
        finally:
            cur.close()

    def update_status(self, log_id, status, **kwargs):
        """Update processing status"""
        if not log_id:
            return
            
        set_clause = ", ".join([f"{k} = %s" for k in kwargs.keys()])
        if set_clause:
            set_clause = ", " + set_clause
            
        values = list(kwargs.values())
        
        cur = self.conn.cursor()
        try:
            cur.execute(f"""
                UPDATE file_processing_log
                SET status = %s, updated_at = NOW() {set_clause}
                WHERE id = %s
            """, [status] + values + [log_id])
            self.conn.commit()
        except Exception as e:
            logger.error(f"Error updating status: {e}")
            self.conn.rollback()
        finally:
            cur.close()

    def mark_completed(self, log_id, stats):
        """Mark file processing completed"""
        if not log_id:
            return

        cur = self.conn.cursor()
        try:
            cur.execute("""
                UPDATE file_processing_log
                SET status = 'completed',
                    processing_completed_at = NOW(),
                    products_added = %s,
                    products_updated = %s,
                    prices_added = %s,
                    updated_at = NOW()
                WHERE id = %s
            """, (stats.get('products', 0), stats.get('updated', 0), stats.get('prices', 0), log_id))
            self.conn.commit()
        except Exception as e:
            logger.error(f"Error marking completed: {e}")
            self.conn.rollback()
        finally:
            cur.close()

    def mark_failed(self, log_id, error):
        """Mark file processing failed"""
        if not log_id:
            return

        cur = self.conn.cursor()
        try:
            cur.execute("""
                UPDATE file_processing_log
                SET status = 'failed',
                    processing_completed_at = NOW(),
                    error_message = %s,
                    updated_at = NOW()
                WHERE id = %s
            """, (str(error), log_id))
            self.conn.commit()
        except Exception as e:
            logger.error(f"Error marking failed: {e}")
            self.conn.rollback()
        finally:
            cur.close()
