
import scrapy

class TestSpider(scrapy.Spider):
    name = "test"
    start_urls = ["https://example.com"]

    def parse(self, response):
        print(f"TEST SUCCESS: {response.url}")
