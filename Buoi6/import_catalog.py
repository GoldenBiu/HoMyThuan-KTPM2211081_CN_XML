import os
from decimal import Decimal, InvalidOperation
from dataclasses import dataclass
from typing import List, Tuple
from lxml import etree
import mysql.connector
from mysql.connector import errorcode
from dotenv import load_dotenv

# -------------------- Cấu hình --------------------
load_dotenv()

MYSQL_CFG = {
    'host': os.getenv('MYSQL_HOST', 'localhost'),
    'port': int(os.getenv('MYSQL_PORT', '3306')),
    'user': os.getenv('MYSQL_USER', 'root'),
    'password': os.getenv('MYSQL_PASSWORD', ''),
    'database': os.getenv('MYSQL_DATABASE', 'ecommerce'),
}

XML_PATH = os.getenv('XML_PATH', 'supplier_catalog.xml')
XSD_PATH = os.getenv('XSD_PATH', 'supplier_catalog.xsd')

# -------------------- Models ----------------------
@dataclass
class Category:
    id: str
    name: str

@dataclass
class Product:
    id: str
    name: str
    price: Decimal
    currency: str
    stock: int
    category_id: str

# -------------------- 1) Parse & Validate --------------------
def load_and_validate(xml_path: str, xsd_path: str) -> etree._ElementTree:
    with open(xsd_path, 'rb') as f:
        schema_doc = etree.parse(f)
        schema = etree.XMLSchema(schema_doc)

    with open(xml_path, 'rb') as f:
        xml_doc = etree.parse(f)

    if not schema.validate(xml_doc):
        errors = [f'Line {e.line}: {e.message}' for e in schema.error_log]
        raise SystemExit(f'[VALIDATION FAILED]\n' + '\n'.join(errors))

    print('[OK] XML hợp lệ với XSD.')
    return xml_doc

# -------------------- 2) Trích dữ liệu --------------------
def extract_categories_and_products(doc: etree._ElementTree) -> Tuple[List[Category], List[Product]]:
    root = doc.getroot()

    cats = [Category(c.get('id'), c.text.strip()) for c in root.xpath('.//categories/category')]
    prods = []
    for p in root.xpath('.//products/product'):
        prods.append(Product(
            id=p.get('id'),
            name=p.findtext('name').strip(),
            price=Decimal(p.findtext('price').strip()),
            currency=p.find('price').get('currency'),
            stock=int(p.findtext('stock')),
            category_id=p.get('categoryRef')
        ))
    return cats, prods

# -------------------- 3) Upsert MySQL --------------------
def upsert_data(conn, categories: List[Category], products: List[Product]):
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS categories (
            id VARCHAR(32) PRIMARY KEY,
            name VARCHAR(255) NOT NULL
        );
    """)
    cur.execute("""
        CREATE TABLE IF NOT EXISTS products (
            id VARCHAR(32) PRIMARY KEY,
            name VARCHAR(255),
            price DECIMAL(12,2),
            currency CHAR(3),
            stock INT,
            category_id VARCHAR(32),
            FOREIGN KEY (category_id) REFERENCES categories(id)
        );
    """)

    cur.executemany(
        "INSERT INTO categories (id, name) VALUES (%s, %s) ON DUPLICATE KEY UPDATE name=VALUES(name)",
        [(c.id, c.name) for c in categories]
    )

    cur.executemany(
        """INSERT INTO products (id, name, price, currency, stock, category_id)
           VALUES (%s, %s, %s, %s, %s, %s)
           ON DUPLICATE KEY UPDATE name=VALUES(name), price=VALUES(price),
           currency=VALUES(currency), stock=VALUES(stock), category_id=VALUES(category_id)""",
        [(p.id, p.name, p.price, p.currency, p.stock, p.category_id) for p in products]
    )

    conn.commit()
    cur.close()

# -------------------- 4) Main --------------------
def main():
    try:
        doc = load_and_validate(XML_PATH, XSD_PATH)
        cats, prods = extract_categories_and_products(doc)
        print(f'[INFO] Số category: {len(cats)} | Số product: {len(prods)}')

        conn = mysql.connector.connect(**MYSQL_CFG)
        upsert_data(conn, cats, prods)
        conn.close()
        print('[OK] Dữ liệu đã được import vào MySQL!')
    except Exception as e:
        print('[ERROR]', e)

if __name__ == '__main__':
    main()
