
-- Insert company
INSERT INTO companies (name) VALUES ('MegaCorp');

-- Insert warehouses
INSERT INTO warehouses (company_id, location) VALUES
(1, 'Mumbai'),
(1, 'Delhi');

-- Insert products
INSERT INTO products (name, description, is_bundle) VALUES
('Laptop', 'High-end gaming laptop', FALSE),
('Mouse', 'Wireless mouse', FALSE),
('Work-from-home Kit', 'Bundle of Laptop + Mouse', TRUE);

-- Insert product bundle composition (bundle_id = 3)
INSERT INTO product_bundles (bundle_id, component_product_id, quantity) VALUES
(3, 1, 1), -- 1 Laptop
(3, 2, 1); -- 1 Mouse

-- Insert suppliers
INSERT INTO suppliers (name, contact_info) VALUES
('TechDistributors', 'tech@distributor.com'),
('GadgetWorld', 'support@gadget.com');

-- Insert supplier-product relationships
INSERT INTO supplier_products (supplier_id, product_id) VALUES
(1, 1),
(1, 2),
(2, 2);

-- Insert inventory
INSERT INTO inventory (warehouse_id, product_id, quantity) VALUES
(1, 1, 10),
(1, 2, 25),
(2, 1, 5),
(2, 2, 15);

-- Insert inventory change logs
INSERT INTO inventory_changes (warehouse_id, product_id, change_amount, reason) VALUES
(1, 1, +10, 'Initial Stock'),
(1, 2, +25, 'Initial Stock'),
(2, 1, +5, 'Restocked'),
(2, 2, +15, 'Restocked');