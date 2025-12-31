# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy

class ScrapedProductItem(scrapy.Item):
    # Primary fields
    url = scrapy.Field()
    name = scrapy.Field()
    price = scrapy.Field()
    currency = scrapy.Field()
    
    # Metadata
    scraped_at = scrapy.Field()
    source_domain = scrapy.Field()
    
    # Matching helpers
    barcode = scrapy.Field()  # EAN/GTIN/ISBN if found
    brand = scrapy.Field()    # Brand name if found
    image_url = scrapy.Field()
    
    # Internal
    source_id = scrapy.Field() # UUID from source_discovery_tracking
    match_confidence = scrapy.Field() # Float 0-1
    master_product_id = scrapy.Field() # UUID if matched
