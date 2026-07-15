/*==============================================================================
 OLIST E-COMMERCE ANALYTICS PROJECT
 File: 01_database_setup.sql

 Purpose:
 This script verifies that the SQLite database has been created correctly
 and that all required tables are available before beginning SQL analysis.

 Author: Sania
==============================================================================*/


/*==============================================================================
Query 1
Business Question:
Which tables are available in the database?
==============================================================================*/

SELECT
    name AS table_name
FROM sqlite_master
WHERE type = 'table'
ORDER BY table_name;



/*==============================================================================
Query 2
Business Question:
How many records are present in the Customers table?
==============================================================================*/

SELECT
    COUNT(*) AS total_customers
FROM customers;



/*==============================================================================
Query 3
Business Question:
How many records are present in the Orders table?
==============================================================================*/

SELECT
    COUNT(*) AS total_orders
FROM orders;



/*==============================================================================
Query 4
Business Question:
How many records are present in the Order Items table?
==============================================================================*/

SELECT
    COUNT(*) AS total_order_items
FROM order_items;



/*==============================================================================
Query 5
Business Question:
How many payment records exist?
==============================================================================*/

SELECT
    COUNT(*) AS total_payments
FROM payments;



/*==============================================================================
Query 6
Business Question:
How many product records exist?
==============================================================================*/

SELECT
    COUNT(*) AS total_products
FROM products;



/*==============================================================================
Query 7
Business Question:
How many review records exist?
==============================================================================*/

SELECT
    COUNT(*) AS total_reviews
FROM reviews;



/*==============================================================================
Query 8
Business Question:
How many sellers are registered?
==============================================================================*/

SELECT
    COUNT(*) AS total_sellers
FROM sellers;



/*==============================================================================
Query 9
Business Question:
How many geolocation records exist?
==============================================================================*/

SELECT
    COUNT(*) AS total_geolocations
FROM geolocation;



/*==============================================================================
Query 10
Business Question:
How many product category translations exist?
==============================================================================*/

SELECT
    COUNT(*) AS total_category_translations
FROM category_translation;



/*==============================================================================
Query 11
Business Question:
What is the schema of the Orders table?
==============================================================================*/

PRAGMA table_info(orders);



/*==============================================================================
Query 12
Business Question:
What is the schema of the Customers table?
==============================================================================*/

PRAGMA table_info(customers);



/*==============================================================================
Query 13
Business Question:
What is the schema of the Order Items table?
==============================================================================*/

PRAGMA table_info(order_items);



/*==============================================================================
Query 14
Business Question:
Preview the first five records from the Orders table.
==============================================================================*/

SELECT *
FROM orders
LIMIT 5;



/*==============================================================================
Query 15
Business Question:
Preview the first five records from the Customers table.
==============================================================================*/

SELECT *
FROM customers
LIMIT 5;



/*==============================================================================
End of File
==============================================================================*/