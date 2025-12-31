import psycopg2
import os
from itemadapter import ItemAdapter

class PriceScannerPipeline:
    def __init__(self):
        self.conn = None
        self.cur = None

    def open_spider(self, spider):
        self.conn = psycopg2.connect(
            dbname=os.getenv('DB_NAME', 'gogobe'),
            user=os.getenv('DB_USER', 'postgres'),
            password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
            host=os.getenv('DB_HOST', 'localhost'),
            port=os.getenv('DB_PORT', '5432')
        )
        self.cur = self.conn.cursor()

    def close_spider(self, spider):
        if self.cur:
            self.cur.close()
        if self.conn:
            self.conn.close()

    def process_item(self, item, spider):
        query = """
            INSERT INTO generic_scraped_prices (
                product_url, product_name, price, currency, 
                barcode, brand, source_domain, image_url, scraped_at
            ) VALUES (
                %s, %s, %s, %s, %s, %s, %s, %s, %s
            )
        """
        adapter = ItemAdapter(item)
        
        try:
            self.cur.execute(query, (
                adapter.get('url'),
                adapter.get('name'),
                adapter.get('price'),
                adapter.get('currency'),
                adapter.get('barcode'),
                adapter.get('brand'),
                adapter.get('source_domain'),
                adapter.get('image_url'),
                adapter.get('scraped_at')
            ))
            self.conn.commit()
        except Exception as e:
            self.conn.rollback()
            spider.logger.error(f"Failed to insert item: {e}")
            # Optionally, don't raise error to keep the spider alive
            # raise DropItem(f"Database error: {e}")
        return item

