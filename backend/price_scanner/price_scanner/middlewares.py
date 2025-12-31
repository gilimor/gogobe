# Define here the models for your spider middleware
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/spider-middleware.html

from scrapy import signals

class PriceScannerSpiderMiddleware:
    # Not all methods need to be defined. If a method is not defined,
    # scrapy acts as if the spider middleware does not modify the
    # passed objects.

    @classmethod
    def from_crawler(cls, crawler):
        # This method is used by Scrapy to create your spiders.
        s = cls()
        crawler.signals.connect(s.spider_opened, signal=signals.spider_opened)
        return s

    def process_spider_input(self, response, spider):
        # Called for each response that goes through the spider
        # middleware and into the spider.

        # Should return None or raise an exception.
        return None

    def process_spider_output(self, response, result, spider):
        # Called with the results returned from the Spider, after
        # it has processed the response.

        # Must return an iterable of Request, or item objects.
        for i in result:
            yield i

    def spider_opened(self, spider):
        spider.logger.info('Spider opened: %s' % spider.name)


import os
import random
import base64

class RotatingProxyMiddleware:
    def __init__(self, proxy_list_env='PROXY_LIST'):
        # Proxies can be comma separated list in env var: "http://user:pass@host:port,http://..."
        proxies_str = os.getenv(proxy_list_env, "")
        self.proxies = [p.strip() for p in proxies_str.split(',') if p.strip()]
        
    @classmethod
    def from_crawler(cls, crawler):
        return cls()

    def process_request(self, request, spider):
        # Don't overwrite if proxy is already set specially
        if 'proxy' in request.meta:
            return

        if not self.proxies:
            # spider.logger.debug("No proxies configured, using direct connection.")
            return

        proxy_url = random.choice(self.proxies)
        
        # Determine strictness: if it's a high-risk site, we MUST use proxy.
        # For now, we just apply it if available.
        request.meta['proxy'] = proxy_url
        
        # Basic auth handling if embedded in URL is not enough (Scrapy handles http://user:pass@host automatically usually)
        # spider.logger.debug(f"Using proxy: {proxy_url}")

