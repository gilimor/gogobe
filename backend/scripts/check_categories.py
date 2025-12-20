#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import psycopg2

sys.stdout.reconfigure(encoding='utf-8')

conn = psycopg2.connect(
    dbname='gogobe',
    user='postgres',
    password='9152245-Gl!',
    host='localhost'
)
cur = conn.cursor()

print("\n=== קטגוריות בבסיס הנתונים ===\n")
cur.execute("""
    SELECT c.id, c.name, c.slug, v.name as vertical_name, COUNT(p.id) as product_count
    FROM categories c
    LEFT JOIN verticals v ON c.vertical_id = v.id
    LEFT JOIN products p ON p.category_id = c.id AND p.is_active = true
    GROUP BY c.id, c.name, c.slug, v.name
    ORDER BY product_count DESC
    LIMIT 20
""")

for row in cur.fetchall():
    print(f"{row[0]:3} | {row[1]:30} | {row[3] or 'N/A':20} | מוצרים: {row[4]}")

print("\n=== מוצרים לפי קטגוריה ===\n")
cur.execute("""
    SELECT 
        COALESCE(c.name, 'ללא קטגוריה') as category,
        COUNT(p.id) as count
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.is_active = true
    GROUP BY c.id, c.name
    ORDER BY count DESC
    LIMIT 10
""")

for row in cur.fetchall():
    print(f"{row[0]:40} | {row[1]:6} מוצרים")

conn.close()
