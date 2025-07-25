

from flask import request
from decimal import Decimal
from sqlalchemy.exc import IntegrityError
from backend_app import db
from models import Product, Inventory

def register_routes(app):
    @app.route('/api/products', methods=['POST'])
    def create_product():
        data = request.json or {}

        required_fields = ['name', 'sku', 'price', 'warehouse_id', 'initial_quantity']
        for field in required_fields:
            if field not in data:
                return {"error": f"Missing required field: {field}"}, 400

        try:
            name = str(data['name'])
            sku = str(data['sku'])
            price = Decimal(str(data['price']))
            warehouse_id = int(data['warehouse_id'])
            initial_quantity = int(data['initial_quantity'])

            if initial_quantity < 0:
                return {"error": "Initial quantity cannot be negative"}, 400
        except Exception as e:
            return {"error": f"Invalid data type: {str(e)}"}, 400

        if Product.query.filter_by(sku=sku).first():
            return {"error": "SKU already exists"}, 400

        try:
            product = Product(
                name=name,
                sku=sku,
                price=price,
                warehouse_id=warehouse_id
            )
            db.session.add(product)
            db.session.flush()

            inventory = Inventory(
                product_id=product.id,
                warehouse_id=warehouse_id,
                quantity=initial_quantity
            )
            db.session.add(inventory)

            db.session.commit()
            return {"message": "Product created", "product_id": product.id}, 201

        except IntegrityError as e:
            db.session.rollback()
            return {"error": f"Integrity error: {str(e)}"}, 400

        except Exception as e:
            db.session.rollback()
            return {"error": f"Unexpected error: {str(e)}"}, 500
