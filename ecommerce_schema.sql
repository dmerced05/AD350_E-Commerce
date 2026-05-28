-- E-Commerce Database Schema (MySQL)
-- Entities derived from Crow's Foot ERD with ISA subtypes
-- Normalized to Boyce-Codd Normal Form (BCNF)
DROP DATABASE IF EXISTS ecommerce;
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- ============================================================
-- CATEGORY
-- ============================================================
CREATE TABLE Category (
    CategoryID  INT           NOT NULL AUTO_INCREMENT,
    Name        VARCHAR(255)  NOT NULL,
    Description TEXT          NULL,
    PRIMARY KEY (CategoryID)
) ENGINE=InnoDB;

-- ============================================================
-- USER
-- ============================================================
CREATE TABLE User (
    UserID        INT          NOT NULL AUTO_INCREMENT,
    Email         VARCHAR(255) NOT NULL,
    PasswordHash  VARCHAR(255) NOT NULL,
    Name          VARCHAR(255) NOT NULL,
    LastLoginDate DATETIME     NULL,
    PRIMARY KEY (UserID),
    UNIQUE KEY uq_user_email (Email)
) ENGINE=InnoDB;

-- ============================================================
-- PRODUCT  (parent entity for ISA hierarchy)
-- ============================================================
CREATE TABLE Product (
    ProductID   INT            NOT NULL AUTO_INCREMENT,
    CategoryID  INT            NOT NULL,
    Name        VARCHAR(255)   NOT NULL,
    Description TEXT           NULL,
    Price       DECIMAL(10,2)  NOT NULL,
    SKU         VARCHAR(100)   NOT NULL,
    CreatedDate DATE           NULL,
    PRIMARY KEY (ProductID),
    UNIQUE KEY uq_product_sku (SKU),
    CONSTRAINT fk_product_category
        FOREIGN KEY (CategoryID) REFERENCES Category (CategoryID)
) ENGINE=InnoDB;

-- ============================================================
-- PHYSICALPRODUCT  (ISA subtype of Product)
-- ============================================================
CREATE TABLE PhysicalProduct (
    ProductID     INT           NOT NULL,
    Weight        DECIMAL(10,3) NULL,
    Dimensions    VARCHAR(100)  NULL,
    ShippingClass VARCHAR(50)   NULL,
    PRIMARY KEY (ProductID),
    CONSTRAINT fk_physprod_product
        FOREIGN KEY (ProductID) REFERENCES Product (ProductID)
) ENGINE=InnoDB;

-- ============================================================
-- DIGITALPRODUCT  (ISA subtype of Product)
-- ============================================================
CREATE TABLE DigitalProduct (
    ProductID   INT          NOT NULL,
    DownloadURL VARCHAR(500) NULL,
    FileSize    BIGINT          NULL,      -- bytes
    LicenseType VARCHAR(100) NULL,
    PRIMARY KEY (ProductID),
    CONSTRAINT fk_digiprod_product
        FOREIGN KEY (ProductID) REFERENCES Product (ProductID)
) ENGINE=InnoDB;

-- ============================================================
-- WAREHOUSE
-- ============================================================
CREATE TABLE Warehouse (
    WarehouseID       INT          NOT NULL AUTO_INCREMENT,
    WarehouseLocation VARCHAR(255) NOT NULL,
    PRIMARY KEY (WarehouseID)
) ENGINE=InnoDB;

-- ============================================================
-- INVENTORY  (Product has-inventory at one Warehouse)
-- ProductID is the sole PK per the ERD; one inventory record per product.
-- ============================================================
CREATE TABLE Inventory (
    ProductID     INT  NOT NULL,
    WarehouseID   INT  NOT NULL,
    Quantity      INT  NOT NULL DEFAULT 0,
    LastRestocked DATE NULL,
    PRIMARY KEY (ProductID),
    CONSTRAINT fk_inventory_product
        FOREIGN KEY (ProductID)   REFERENCES Product   (ProductID),
    CONSTRAINT fk_inventory_warehouse
        FOREIGN KEY (WarehouseID) REFERENCES Warehouse (WarehouseID)
) ENGINE=InnoDB;

-- ============================================================
-- ORDER  (backtick-quoted because ORDER is a MySQL reserved word)
-- ============================================================
CREATE TABLE `Order` (
    OrderID   INT           NOT NULL AUTO_INCREMENT,
    UserID    INT           NOT NULL,
    OrderDate DATE          NOT NULL,
    Status    VARCHAR(50)   NOT NULL,
    Amount    DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (OrderID),
    CONSTRAINT fk_order_user
        FOREIGN KEY (UserID) REFERENCES User (UserID)
) ENGINE=InnoDB;

-- ============================================================
-- ORDERITEM  (junction / associative entity between Order & Product)
-- ============================================================
CREATE TABLE OrderItem (
    OrderID         INT           NOT NULL,
    ProductID       INT           NOT NULL,
    Quantity        INT           NOT NULL,
    UnitPriceAtSale DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (OrderID, ProductID),
    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (OrderID)   REFERENCES `Order`  (OrderID),
    CONSTRAINT fk_orderitem_product
        FOREIGN KEY (ProductID) REFERENCES Product  (ProductID)
) ENGINE=InnoDB;

-- ============================================================
-- REVIEW  (composite PK: one review per user per product)
-- ============================================================
CREATE TABLE Review (
    UserID     INT  NOT NULL,
    ProductID  INT  NOT NULL,
    Rating     INT  NOT NULL,
    Text       TEXT NULL,
    ReviewDate DATE NOT NULL,
    PRIMARY KEY (UserID, ProductID),
    CONSTRAINT fk_review_user
        FOREIGN KEY (UserID)    REFERENCES User    (UserID),
    CONSTRAINT fk_review_product
        FOREIGN KEY (ProductID) REFERENCES Product (ProductID)
) ENGINE=InnoDB;
