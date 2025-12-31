"""
Redis Streams Queue Manager
Production-ready message queue for distributed import
"""
import redis
import json
import time
from typing import Dict, Any, List
from datetime import datetime

class ImportQueue:
    """
    Redis Streams-based distributed queue
    Handles 1000s of concurrent import jobs
    """
    
    def __init__(self, redis_host='redis', redis_port=6379):
        self.redis = redis.Redis(
            host=redis_host,
            port=redis_port,
            decode_responses=True
        )
        
        # Stream names
        self.DOWNLOAD = 'import:download'
        self.PARSE = 'import:parse'
        self.PROCESS = 'import:process'
        
        # Ensure consumer groups exist
        self._init_streams()
    
    def _init_streams(self):
        """Initialize streams and consumer groups"""
        groups = [
            (self.DOWNLOAD, 'downloaders'),
            (self.PARSE, 'parsers'),
            (self.PROCESS, 'processors')
        ]
        
        for stream, group in groups:
            try:
                self.redis.xgroup_create(stream, group, id='0', mkstream=True)
            except redis.exceptions.ResponseError as e:
                if 'BUSYGROUP' not in str(e):
                    raise
    
    # DOWNLOAD QUEUE
    def add_download_job(self, source_id: str, file_metadata: Dict) -> str:
        """Add file to download queue"""
        job = {
            'source_id': source_id,
            'filename': file_metadata.get('filename', ''),
            'url': file_metadata.get('url', ''),
            'store_code': file_metadata.get('store_code', ''),
            'timestamp': int(time.time())
        }
        
        msg_id = self.redis.xadd(self.DOWNLOAD, job)
        return msg_id
    
    def get_download_jobs(self, consumer_name: str, count=10, block=5000):
        """Get download jobs for worker"""
        messages = self.redis.xreadgroup(
            groupname='downloaders',
            consumername=consumer_name,
            streams={self.DOWNLOAD: '>'},
            count=count,
            block=block
        )
        
        return self._extract_messages(messages)
    
    # PARSE QUEUE
    def add_parse_job(self, source_id: str, filepath: str, metadata: Dict) -> str:
        """Add file to parse queue"""
        job = {
            'source_id': source_id,
            'filepath': filepath,
            'filename': metadata.get('filename', ''),
            'store_code': metadata.get('store_code', ''),
            'timestamp': int(time.time())
        }
        
        msg_id = self.redis.xadd(self.PARSE, job)
        return msg_id
    
    def get_parse_jobs(self, consumer_name: str, count=10):
        """Get parse jobs for worker"""
        messages = self.redis.xreadgroup(
            groupname='parsers',
            consumername=consumer_name,
            streams={self.PARSE: '>'},
            count=count,
            block=5000
        )
        
        return self._extract_messages(messages)
    
    # PROCESS QUEUE  
    def add_process_job(self, source_id: str, products: List[Dict], store_id: int) -> str:
        """Add products to process queue"""
        job = {
            'source_id': source_id,
            'products': json.dumps(products),
            'store_id': store_id,
            'count': len(products),
            'timestamp': int(time.time())
        }
        
        msg_id = self.redis.xadd(self.PROCESS, job)
        return msg_id
    
    def get_process_jobs(self, consumer_name: str, count=10):
        """Get process jobs for worker"""
        messages = self.redis.xreadgroup(
            groupname='processors',
            consumername=consumer_name,
            streams={self.PROCESS: '>'},
            count=count,
            block=5000
        )
        
        return self._extract_messages(messages)
    
    # ACKNOWLEDGEMENT
    def ack(self, stream: str, group: str, msg_id: str):
        """Acknowledge message processed"""
        self.redis.xack(stream, group, msg_id)
    
    def ack_download(self, msg_id: str):
        self.ack(self.DOWNLOAD, 'downloaders', msg_id)
    
    def ack_parse(self, msg_id: str):
        self.ack(self.PARSE, 'parsers', msg_id)
    
    def ack_process(self, msg_id: str):
        self.ack(self.PROCESS, 'processors', msg_id)
    
    # STATS
    def get_stats(self) -> Dict:
        """Get queue statistics"""
        stats = {}
        
        for stream in [self.DOWNLOAD, self.PARSE, self.PROCESS]:
            try:
                info = self.redis.xinfo_stream(stream)
                stats[stream] = {
                    'length': info['length'],
                    'groups': info['groups']
                }
            except:
                stats[stream] = {'length': 0, 'groups': 0}
        
        return stats
    
    def clear_all(self):
        """Clear all streams (for testing)"""
        for stream in [self.DOWNLOAD, self.PARSE, self.PROCESS]:
            try:
                self.redis.delete(stream)
            except:
                pass
        self._init_streams()
    
    # HELPERS
    def _extract_messages(self, messages):
        """Extract message data from Redis response"""
        results = []
        
        for stream, items in messages:
            for msg_id, data in items:
                results.append({
                    'id': msg_id,
                    'stream': stream.decode() if isinstance(stream, bytes) else stream,
                    'data': data
                })
        
        return results
