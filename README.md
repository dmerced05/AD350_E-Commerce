# AD350_E-Commerce
AD350_E-Commerce
## Scamazon E-Commerce DB Design
## Strong and Weak Entity Documentation

### Strong Entities

Strong entities are entities that have their own primary key and can exist independently without needing another entity to identify them.

In this database, the strong entities are:

```text
USER
CATEGORY
PRODUCT
ORDER
WAREHOUSE
```

`USER` is a strong entity because each user has a unique `UserID` and can exist even before placing an order or writing a review.

`CATEGORY` is a strong entity because each category has its own `CategoryID` and can exist independently of a specific product.

`PRODUCT` is a strong entity because each product has a unique `ProductID` and stores general product information such as name, description, price, and SKU.

`ORDER` is a strong entity because each order has a unique `OrderID`. Although an order is related to a user, it still has its own identity and stores order-specific information such as order date, status, and amount.

`WAREHOUSE` is a strong entity because each warehouse has a unique `WarehouseID` and stores information about a warehouse location.

---

## Weak / Associative Entities

Weak or associative entities depend on other entities for their meaning. They often include foreign keys from other tables and are used to connect relationships.

In this database, the weak or associative entities are:

```text
ORDERITEM
REVIEW
INVENTORY
PHYSICALPRODUCT
DIGITALPRODUCT
```

`ORDERITEM` is an associative entity between `ORDER` and `PRODUCT`. One order can contain many products, and one product can appear in many different orders. The composite key of `OrderID` and `ProductID` identifies each product within an order.

`REVIEW` is an associative entity between `USER` and `PRODUCT`. One user can write many reviews, and one product can receive many reviews. The composite key of `UserID` and `ProductID` also enforces the rule that a user can only review a specific product once.

`INVENTORY` is an associative entity between `PRODUCT` and `WAREHOUSE`. One product can be stored in multiple warehouses, and one warehouse can store many products. The inventory record tracks the quantity of a specific product at a specific warehouse.

`PHYSICALPRODUCT` and `DIGITALPRODUCT` are subtype entities. They depend on `PRODUCT` because their primary key, `ProductID`, is also a foreign key that references the `PRODUCT` table.

---

## Supertype and Subtype Documentation

This ERD includes one supertype/subtype relationship:

```text
PRODUCT
├── PHYSICALPRODUCT
└── DIGITALPRODUCT
```

`PRODUCT` is the supertype entity because it contains attributes shared by all products, including:

```text
ProductID
CategoryID
Name
Description
Price
SKU
```

`PHYSICALPRODUCT` and `DIGITALPRODUCT` are subtype entities because they store attributes that only apply to specific kinds of products.

`PHYSICALPRODUCT` stores physical-item attributes:

```text
Weight
Dimensions
ShippingClass
```

`DIGITALPRODUCT` stores digital-item attributes:

```text
DownloadURL
FileSize
LicenseType
```

This subtype relationship is disjoint, because a product should be either physical or digital, not both.

---

## Cardinality Explanation

A `CATEGORY` can contain many `PRODUCT` records, but each product belongs to one category.

A `USER` can place many `ORDER` records, but each order belongs to one user.

An `ORDER` can contain many `ORDERITEM` records, but each order item belongs to one order.

A `PRODUCT` can appear in many `ORDERITEM` records, but each order item refers to one product.

A `USER` can write many `REVIEW` records, but each review belongs to one user.

A `PRODUCT` can receive many `REVIEW` records, but each review is for one product.

A `PRODUCT` can have many `INVENTORY` records, and each inventory record belongs to one product.

A `WAREHOUSE` can have many `INVENTORY` records, and each inventory record belongs to one warehouse.

A `PRODUCT` can have one related `PHYSICALPRODUCT` record or one related `DIGITALPRODUCT` record, depending on the product type.
