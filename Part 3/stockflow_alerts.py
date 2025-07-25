# alerts.py

from flask import request
from datetime import datetime, timedelta
from sqlalchemy import func
from backend_app import app, db
from models import Product, Inventory, Warehouse, Supplier, ProductSupplier, Sale  # assuming these exist

def register_alert_routes(app):
    @app.route('/api/companies/<int:company_id>/alerts/low-stock', methods=['GET'])
    def low_stock_alerts(company_id):
        alerts = []

        # Get all warehouses for this company
        warehouses = Warehouse.query.filter_by(company_id=company_id).all()

        for warehouse in warehouses:
            # Get all inventory entries in this warehouse
            inventory_entries = (
                db.session.query(Inventory)
                .filter_by(warehouse_id=warehouse.id)
                .all()
            )

            for inv in inventory_entries:
                product = Product.query.get(inv.product_id)

                # Skip if no threshold set (assumed stored in product table)
                if not hasattr(product, 'low_stock_threshold') or product.low_stock_threshold is None:
                    continue

                # Skip if stock is above threshold
                if inv.quantity >= product.low_stock_threshold:
                    continue

                # Check if product has recent sales (last 7 days)
                one_week_ago = datetime.utcnow() - timedelta(days=7)
                sales = (
                    db.session.query(func.sum(Sale.quantity))
                    .filter(Sale.product_id == product.id)
                    .filter(Sale.warehouse_id == warehouse.id)
                    .filter(Sale.timestamp >= one_week_ago)
                    .scalar() or 0
                )

                if sales == 0:
                    continue  # no recent sales

                avg_daily_sales = sales / 7
                days_until_stockout = int(inv.quantity / avg_daily_sales) if avg_daily_sales > 0 else None

                # Get supplier (first one)
                supplier = (
                    db.session.query(Supplier)
                    .join(ProductSupplier, Supplier.id == ProductSupplier.supplier_id)
                    .filter(ProductSupplier.product_id == product.id)
                    .first()
                )

                alerts.append({
                    "product_id": product.id,
                    "product_name": product.name,
                    "sku": product.sku,
                    "warehouse_id": warehouse.id,
                    "warehouse_name": warehouse.name,
                    "current_stock": inv.quantity,
                    "threshold": product.low_stock_threshold,
                    "days_until_stockout": days_until_stockout,
                    "supplier": {
                        "id": supplier.id if supplier else None,
                        "name": supplier.name if supplier else None,
                        "contact_email": supplier.contact_email if supplier else None
                    }
                })

        return {
            "alerts": alerts,
            "total_alerts": len(alerts)
        }
