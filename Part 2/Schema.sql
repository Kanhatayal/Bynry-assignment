-- Table: companies
CREATE TABLE companies (
    company_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

-- Table: warehouses
CREATE TABLE warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    company_id INT NOT NULL,
    location VARCHAR(255),
    FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE
);

-- Table: products
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    is_bundle BOOLEAN DEFAULT FALSE
);

-- Table: product_bundles
CREATE TABLE product_bundles (
    bundle_id INT,
    component_product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (bundle_id, component_product_id),
    FOREIGN KEY (bundle_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (component_product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Table: suppliers
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_info TEXT
);

-- Table: supplier_products
CREATE TABLE supplier_products (
    supplier_id INT,
    product_id INT,
    PRIMARY KEY (supplier_id, product_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Table: inventory
CREATE TABLE inventory (
    warehouse_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity >= 0),
    PRIMARY KEY (warehouse_id, product_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

CREATE TABLE inventory_changes (
    change_id SERIAL PRIMARY KEY,
    warehouse_id INT,
    product_id INT,
    change_amount INT NOT NULL,
    reason VARCHAR(255),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (warehouse_id, product_id)
        REFERENCES inventory(warehouse_id, product_id)
);

