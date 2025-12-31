#!/usr/bin/env python3
"""
Redis Cache Manager for Gogobe
High-performance caching layer for product/store/chain lookups
Target: 99% cache hit rate
"""

import redis
import json
from typing import Optional, Dict, Any, List
import logging
from datetime import timedelta

logger = logging.getLogger(__name__)


class RedisCache:
    """
    Redis cache manager for Gogobe
    
    Cache Strategy:
    - Products by EAN: 24h TTL (99% hit rate expected)
    - Stores: 24h TTL (95% hit rate)
    - Chains: 7 days TTL (100% hit rate - rarely change)
    - Master Products: 24h TTL
    """
    
    def __init__(self, host=None, port=6379, db=0, password=None):
        """Initialize Redis connection"""
        import os
        # Default to environment variable, fallback to localhost
        if host is None:
            host = os.getenv('REDIS_HOST', 'localhost')
        
        try:
            self.redis = redis.Redis(
                host=host,
                port=port,
                db=db,
                password=password,
                decode_responses=True,  # Auto-decode to strings
                socket_timeout=5,
                socket_connect_timeout=5
            )
            # Test connection
            self.redis.ping()
            logger.info(f"✓ Connected to Redis at {host}:{port}")
        except redis.ConnectionError as e:
            logger.error(f"✗ Failed to connect to Redis: {e}")
            logger.warning("Running WITHOUT cache - performance will be degraded!")
            self.redis = None
    
    def _is_connected(self) -> bool:
        """Check if Redis is available"""
        return self.redis is not None
    
    # ========================================
    # PRODUCT CACHE
    # ========================================
    
    def get_product_id(self, barcode: str) -> Optional[int]:
        """
        Get product ID by barcode (EAN)
        
        Args:
            barcode: Product EAN/barcode
            
        Returns:
            Product ID or None if not cached
        """
        if not self._is_connected():
            return None
            
        try:
            key = f"product:ean:{barcode}"
            value = self.redis.get(key)
            if value:
                logger.debug(f"✓ Cache HIT: {barcode} → {value}")
                return int(value)
            logger.debug(f"✗ Cache MISS: {barcode}")
            return None
        except Exception as e:
            logger.warning(f"Cache error (get_product_id): {e}")
            return None
    
    def cache_product(self, barcode: str, product_id: int, ttl_hours: int = 24):
        """
        Cache product ID by barcode
        
        Args:
            barcode: Product EAN/barcode
            product_id: Product database ID
            ttl_hours: Time to live in hours (default: 24)
        """
        if not self._is_connected():
            return
            
        try:
            key = f"product:ean:{barcode}"
            self.redis.setex(
                key,
                timedelta(hours=ttl_hours),
                str(product_id)
            )
            logger.debug(f"✓ Cached: {barcode} → {product_id} (TTL: {ttl_hours}h)")
        except Exception as e:
            logger.warning(f"Cache error (cache_product): {e}")
    
    def cache_products_batch(self, products: Dict[str, int], ttl_hours: int = 24):
        """
        Cache multiple products at once (more efficient)
        
        Args:
            products: Dict of {barcode: product_id}
            ttl_hours: Time to live in hours
        """
        if not self._is_connected() or not products:
            return
            
        try:
            pipe = self.redis.pipeline()
            for barcode, product_id in products.items():
                key = f"product:ean:{barcode}"
                pipe.setex(key, timedelta(hours=ttl_hours), str(product_id))
            pipe.execute()
            logger.info(f"✓ Batch cached {len(products)} products")
        except Exception as e:
            logger.warning(f"Cache error (cache_products_batch): {e}")
    
    # ========================================
    # STORE CACHE
    # ========================================
    
    def get_store_id(self, chain_id: int, store_code: str) -> Optional[int]:
        """
        Get store ID by chain + store code
        
        Args:
            chain_id: Database chain ID
            store_code: Store identifier (e.g., "7290058140886_001")
            
        Returns:
            Store ID or None if not cached
        """
        if not self._is_connected():
            return None
            
        try:
            key = f"store:{chain_id}:{store_code}"
            value = self.redis.get(key)
            if value:
                logger.debug(f"✓ Cache HIT: store {chain_id}:{store_code} → {value}")
                return int(value)
            return None
        except Exception as e:
            logger.warning(f"Cache error (get_store_id): {e}")
            return None
    
    def cache_store(self, chain_id: int, store_code: str, store_id: int, ttl_hours: int = 24):
        """Cache store ID"""
        if not self._is_connected():
            return
            
        try:
            key = f"store:{chain_id}:{store_code}"
            self.redis.setex(key, timedelta(hours=ttl_hours), str(store_id))
            logger.debug(f"✓ Cached store: {chain_id}:{store_code} → {store_id}")
        except Exception as e:
            logger.warning(f"Cache error (cache_store): {e}")
    
    # ========================================
    # CHAIN CACHE
    # ========================================
    
    def get_chain_id(self, chain_code: str) -> Optional[int]:
        """Get chain ID by chain code"""
        if not self._is_connected():
            return None
            
        try:
            key = f"chain:code:{chain_code}"
            value = self.redis.get(key)
            if value:
                return int(value)
            return None
        except Exception as e:
            logger.warning(f"Cache error (get_chain_id): {e}")
            return None
    
    def cache_chain(self, chain_code: str, chain_id: int, ttl_days: int = 7):
        """Cache chain ID (chains rarely change, so longer TTL)"""
        if not self._is_connected():
            return
            
        try:
            key = f"chain:code:{chain_code}"
            self.redis.setex(key, timedelta(days=ttl_days), str(chain_id))
            logger.debug(f"✓ Cached chain: {chain_code} → {chain_id}")
        except Exception as e:
            logger.warning(f"Cache error (cache_chain): {e}")
    
    # ========================================
    # MASTER PRODUCT CACHE
    # ========================================
    
    def get_master_product_id(self, barcode: str) -> Optional[int]:
        """Get master product ID by global barcode"""
        if not self._is_connected():
            return None
            
        try:
            key = f"master:ean:{barcode}"
            value = self.redis.get(key)
            if value:
                return int(value)
            return None
        except Exception as e:
            logger.warning(f"Cache error (get_master_product_id): {e}")
            return None
    
    def cache_master_product(self, barcode: str, master_id: int, ttl_hours: int = 24):
        """Cache master product ID"""
        if not self._is_connected():
            return
            
        try:
            key = f"master:ean:{barcode}"
            self.redis.setex(key, timedelta(hours=ttl_hours), str(master_id))
        except Exception as e:
            logger.warning(f"Cache error (cache_master_product): {e}")
    
    # ========================================
    # STATISTICS & MONITORING
    # ========================================
    
    def get_stats(self) -> Dict[str, Any]:
        """Get cache statistics"""
        if not self._is_connected():
            return {"status": "disconnected"}
            
        try:
            info = self.redis.info('stats')
            return {
                "status": "connected",
                "total_keys": self.redis.dbsize(),
                "hits": info.get('keyspace_hits', 0),
                "misses": info.get('keyspace_misses', 0),
                "hit_rate": self._calculate_hit_rate(
                    info.get('keyspace_hits', 0),
                    info.get('keyspace_misses', 0)
                ),
                "memory_used": info.get('used_memory_human', 'N/A'),
            }
        except Exception as e:
            logger.error(f"Failed to get cache stats: {e}")
            return {"status": "error", "error": str(e)}
    
    def _calculate_hit_rate(self, hits: int, misses: int) -> float:
        """Calculate cache hit rate percentage"""
        total = hits + misses
        if total == 0:
            return 0.0
        return (hits / total) * 100
    
    def clear_all(self):
        """Clear all cache (use with caution!)"""
        if not self._is_connected():
            return
            
        try:
            self.redis.flushdb()
            logger.warning("⚠️ Cache cleared!")
        except Exception as e:
            logger.error(f"Failed to clear cache: {e}")
    
    def warmup_products(self, products: List[tuple]):
        """
        Warm up cache with product data
        
        Args:
            products: List of (barcode, product_id) tuples
        """
        if not products:
            return
            
        products_dict = {barcode: pid for barcode, pid in products}
        self.cache_products_batch(products_dict)
        logger.info(f"✓ Cache warmed up with {len(products)} products")


# ========================================
# SINGLETON INSTANCE
# ========================================
_cache_instance = None

def get_cache(host=None, port=6379, db=0, password=None) -> RedisCache:
    """Get singleton cache instance"""
    global _cache_instance
    if _cache_instance is None:
        _cache_instance = RedisCache(host, port, db, password)
    return _cache_instance


# ========================================
# USAGE EXAMPLE
# ========================================
if __name__ == "__main__":
    # Initialize cache
    cache = get_cache()
    
    # Example: Cache a product
    cache.cache_product("7290000000001", 12345)
    
    # Example: Lookup
    product_id = cache.get_product_id("7290000000001")
    print(f"Product ID: {product_id}")
    
    # Example: Get stats
    stats = cache.get_stats()
    print(f"Cache stats: {stats}")
