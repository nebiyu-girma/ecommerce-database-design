-- Core Tables
CREATE TABLE brand (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE product_category (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    parent_category_id INT,
    FOREIGN KEY (parent_category_id) REFERENCES product_category(id)
);

CREATE TABLE product (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    base_price DECIMAL(10,2) NOT NULL,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (brand_id) REFERENCES brand(id),
    FOREIGN KEY (category_id) REFERENCES product_category(id)
);

-- Variations & Inventory
CREATE TABLE color (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    hex_code VARCHAR(7)
);

CREATE TABLE size_category (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE  -- e.g., "Clothing", "Shoes"
);

CREATE TABLE size_option (
    id INT PRIMARY KEY AUTO_INCREMENT,
    size_name VARCHAR(20) NOT NULL,  -- e.g., "M", "42"
    size_category_id INT NOT NULL,
    FOREIGN KEY (size_category_id) REFERENCES size_category(id)
);

CREATE TABLE product_variation (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    color_id INT,
    size_option_id INT,
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (color_id) REFERENCES color(id),
    FOREIGN KEY (size_option_id) REFERENCES size_option(id),
    CHECK (color_id IS NOT NULL OR size_option_id IS NOT NULL)  -- Ensure at least one variation
);

CREATE TABLE product_item (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_variation_id INT NOT NULL,
    SKU VARCHAR(50) UNIQUE NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    inventory INT NOT NULL DEFAULT 0,
    FOREIGN KEY (product_variation_id) REFERENCES product_variation(id)
);

CREATE TABLE product_image (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_item_id INT NOT NULL,
    image_url VARCHAR(512) NOT NULL,
    FOREIGN KEY (product_item_id) REFERENCES product_item(id)
);

-- Attributes & Metadata
CREATE TABLE attribute_category (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE  -- e.g., "Physical", "Technical"
);

CREATE TABLE attribute_type (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,  -- e.g., "Material", "Weight"
    data_type ENUM('text', 'number', 'boolean') NOT NULL,
    attribute_category_id INT NOT NULL,
    FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(id)
);

CREATE TABLE product_attribute (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    attribute_type_id INT NOT NULL,
    value VARCHAR(255) NOT NULL,  -- Stored as string; cast to data_type during retrieval
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (attribute_type_id) REFERENCES attribute_type(id),
    UNIQUE (product_id, attribute_type_id)  -- Prevent duplicate attributes
);
