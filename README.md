
# 📦 StockFlow – Inventory Management Case Study

This project is a submission for the Backend Engineering Intern Case Study. The goal was to build and debug an inventory system API for a B2B SaaS platform called StockFlow, which helps companies manage products, warehouses, and supplier relationships.

The case study is divided into three main parts:
- Code review and debugging
- Database schema design
- API implementation for low-stock alerts

---

## ✅ Part 1: Code Review & Debugging

The initial task was to review an existing `/api/products` endpoint that wasn’t behaving correctly in production. The code was functional but had multiple issues, both technical and logical.

### 🔍 Key Issues Identified

- The SKU was not being checked for uniqueness, which could result in duplicate product entries.
- The `warehouse_id` was stored inside the `products` table, even though products can exist across multiple warehouses.
- There was no input validation or type checking, which meant the endpoint could fail unexpectedly.
- The price field was handled as a float, which can cause rounding issues — especially important for money.
- Product and inventory were committed in two separate DB operations, risking inconsistent state if one fails.
- There was no error handling in place to return meaningful messages to the client.

### 🛠️ Fixes Applied

- Added checks for required fields and validated their data types.
- Used Python’s `Decimal` type to handle price precisely.
- Introduced a duplicate SKU check before creating a product.
- Wrapped product and inventory creation in a single transaction using `try-except`.
- Added clear and user-friendly error messages for all failure cases.

> ✅ After these changes, the `/api/products` endpoint works reliably with proper validation, atomic transactions, and clean error handling.

---

## 🏗️ Part 2: Database Design

The second part focused on designing a schema to support core inventory operations such as multi-warehouse storage, supplier relationships, and bundle products.

### 📊 Tables Created

- `companies(id, name)`
- `warehouses(id, company_id, name, location)`
- `products(id, sku, name, price, low_stock_threshold, is_bundle)`
- `inventories(id, product_id, warehouse_id, quantity)`
- `inventory_changes(id, inventory_id, change, reason, changed_at)`
- `suppliers(id, name, contact_email)`
- `product_suppliers(product_id, supplier_id)`
- `product_bundles(bundle_id, child_product_id, quantity)`

### ❓ Questions I Considered

- Should low stock thresholds be global per product, or customizable per warehouse?
- Are product bundles treated as separate inventory items or calculated dynamically?
- Is pricing ever different per warehouse or customer tier?
- Do inventory changes need to be tracked per user or only system-wide?

### 💡 Design Notes

- The schema is normalized and designed to support scalable multi-warehouse and multi-supplier operations.
- Inventory is tracked per warehouse with a composite uniqueness constraint.
- `product_suppliers` and `product_bundles` handle many-to-many relationships.
- `inventory_changes` was added to allow for tracking stock level modifications, useful for analytics or auditing.
- `low_stock_threshold` is stored in the `products` table for simplicity.

> ✅ The schema supports all required use cases while remaining clean and extendable.

---

## 🔔 Part 3: Low-Stock Alerts API

The final part involved implementing a GET endpoint to show low-stock alerts for a company across all its warehouses.

### 🔗 Endpoint

```http
GET /api/companies/<company_id>/alerts/low-stock
