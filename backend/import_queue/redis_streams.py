"""
RECOMMENDED: Redis Streams Architecture
Why Redis Streams > Kafka for our use case:

✅ PROS:
- Already have Redis running
- Lighter weight (no JVM)
- Built-in persistence
- Consumer groups (like Kafka)
- Simpler to manage
- Lower latency
- Perfect for 1000s of sources

❌ Kafka would add:
- Extra infrastructure (Zookeeper + Kafka brokers)
- More complexity
- Higher resource usage
- Overkill for our scale

ARCHITECTURE WITH REDIS STREAMS:
================================

Stream Structure:
-----------------
downloads_stream → [file_metadata, url, source_id]
parse_stream → [filepath, source_id, format]
process_stream → [products, store_id]
master_stream → [product_ids, strategy]

Consumer Groups:
----------------
downloaders (5 consumers) → downloads_stream
parsers (10 consumers) → parse_stream  
processors (8 consumers) → process_stream
matchers (3 consumers) → master_stream

Implementation:
===============
"""

import redis
import json
from typing import Dict, Any

class RedisStreamQueue:
    """
    Redis Streams-based message queue
    Production-ready, scalable to 1000s of sources
    """
    
    def __init__(self, redis_host='redis', redis_port=6379):
        self.redis = redis.Redis(
            host=redis_host,
            port=redis_port,
            decode_responses=True
        )
        
        # Stream names
        self.DOWNLOAD_STREAM = 'import:downloads'
        self.PARSE_STREAM = 'import:parse'
        self.PROCESS_STREAM = 'import:process'
        self.MASTER_STREAM = 'import:master'
        
        # Consumer groups
        self._ensure_consumer_groups()
    
    def _ensure_consumer_groups(self):
        """Create consumer groups if they don't exist"""
        streams = [
            (self.DOWNLOAD_STREAM, 'downloaders'),
            (self.PARSE_STREAM, 'parsers'),
            (self.PROCESS_STREAM, 'processors'),
            (self.MASTER_STREAM, 'matchers')
        ]
        
        for stream, group in streams:
            try:
                self.redis.xgroup_create(stream, group, id='0', mkstream=True)
            except redis.exceptions.ResponseError:
                # Group already exists
                pass
    
    def enqueue_download(self, source_id: str, url: str, metadata: Dict[str, Any]):
        """Add file to download queue"""
        message = {
            'source_id': source_id,
            'url': url,
            'metadata': json.dumps(metadata),
            'timestamp': str(int(time.time()))
        }
        
        message_id = self.redis.xadd(self.DOWNLOAD_STREAM, message)
        return message_id
    
    def consume_downloads(self, consumer_name: str, block_ms=5000):
        """Consume download tasks"""
        messages = self.redis.xreadgroup(
            groupname='downloaders',
            consumername=consumer_name,
            streams={self.DOWNLOAD_STREAM: '>'},
            count=10,
            block=block_ms
        )
        
        return self._process_messages(messages)
    
    def enqueue_parse(self, filepath: str, source_id: str, format_type: str):
        """Add file to parse queue"""
        message = {
            'filepath': filepath,
            'source_id': source_id,
            'format': format_type,
            'timestamp': str(int(time.time()))
        }
        
        return self.redis.xadd(self.PARSE_STREAM, message)
    
    def consume_parse(self, consumer_name: str):
        """Consume parse tasks"""
        messages = self.redis.xreadgroup(
            groupname='parsers',
            consumername=consumer_name,
            streams={self.PARSE_STREAM: '>'},
            count=10,
            block=5000
        )
        
        return self._process_messages(messages)
    
    def acknowledge(self, stream: str, group: str, message_id: str):
        """Acknowledge message processed"""
        self.redis.xack(stream, group, message_id)
    
    def _process_messages(self, messages):
        """Extract message data"""
        results = []
        for stream, items in messages:
            for message_id, data in items:
                results.append({
                    'id': message_id,
                    'stream': stream,
                    'data': data
                })
        return results
    
    def get_stream_info(self, stream: str):
        """Get stream stats"""
        info = self.redis.xinfo_stream(stream)
        return {
            'length': info['length'],
            'groups': info['groups'],
            'first_entry': info.get('first-entry'),
            'last_entry': info.get('last-entry')
        }


# WORKER EXAMPLE:
# ===============

"""
File: backend/workers/downloader_worker.py

from queue.redis_streams import RedisStreamQueue
import time

def main():
    queue = RedisStreamQueue()
    consumer_name = f"downloader-{os.getpid()}"
    
    print(f"Worker {consumer_name} starting...")
    
    while True:
        # Consume messages
        messages = queue.consume_downloads(consumer_name)
        
        for msg in messages:
            try:
                # Download file
                source_id = msg['data']['source_id']
                url = msg['data']['url']
                
                filepath = download_file(url)
                
                # Add to parse queue
                queue.enqueue_parse(
                    filepath=filepath,
                    source_id=source_id,
                    format_type='xml'
                )
                
                # Acknowledge
                queue.acknowledge(
                    queue.DOWNLOAD_STREAM,
                    'downloaders',
                    msg['id']
                )
                
            except Exception as e:
                print(f"Error: {e}")
                # Don't acknowledge - will retry


# RUN WORKERS:
# ============

# Terminal 1 - Downloaders
for i in {1..5}; do
    python backend/workers/downloader_worker.py &
done

# Terminal 2 - Parsers  
for i in {1..10}; do
    python backend/workers/parser_worker.py &
done

# Terminal 3 - Processors
for i in {1..8}; do
    python backend/workers/processor_worker.py &
done


# MONITORING:
# ===========

redis-cli INFO STREAMS
redis-cli XINFO STREAM import:downloads
redis-cli XINFO GROUPS import:downloads


# DOCKER SCALING:
# ===============

docker-compose up --scale downloader=5 --scale parser=10 --scale processor=8
"""

print(__doc__)
