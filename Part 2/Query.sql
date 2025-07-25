-- Query 1
SELECT p.name, SUM(i.quantity) AS total_quantity
FROM inventory i
JOIN products p ON i.product_id = p.product_id
GROUP BY p.name;

-- Query 2
SELECT b.bundle_id, p.name AS component_name, b.quantity
FROM product_bundles b
JOIN products p ON b.component_product_id = p.product_id
WHERE b.bundle_id = 3;


-- Query 3
SELECT c.name AS company, w.location, p.name AS product, ic.change_amount, ic.reason, ic.changed_at
FROM inventory_changes ic
JOIN warehouses w ON ic.warehouse_id = w.warehouse_id
JOIN companies c ON w.company_id = c.company_id
JOIN products p ON ic.product_id = p.product_id
ORDER BY ic.changed_at DESC;