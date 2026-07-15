# =====================================================
# EXECUTIVE DASHBOARD
# =====================================================

def total_orders():
    return """
    SELECT COUNT(*) AS value
    FROM orders;
    """


def total_customers():
    return """
    SELECT COUNT(DISTINCT customer_unique_id) AS value
    FROM customers;
    """


def total_revenue():
    return """
    SELECT ROUND(SUM(payment_value),2) AS value
    FROM payments;
    """


def average_order_value():
    return """
    SELECT ROUND(AVG(payment_value),2) AS value
    FROM payments;
    """


def monthly_revenue():
    return """
    SELECT
        strftime('%Y-%m',order_purchase_timestamp) AS Month,
        SUM(payment_value) AS Revenue
    FROM orders
    JOIN payments
        ON orders.order_id=payments.order_id
    GROUP BY Month
    ORDER BY Month;
    """


def order_status_distribution():
    return """
    SELECT
        order_status,
        COUNT(*) AS Orders
    FROM orders
    GROUP BY order_status;
    """


def payment_distribution():
    return """
    SELECT
        payment_type,
        COUNT(*) AS Orders
    FROM payments
    GROUP BY payment_type;
    """


# =====================================================
# SALES ANALYSIS
# =====================================================

def revenue_by_month():
    return """
    SELECT
        strftime('%Y-%m',order_purchase_timestamp) AS Month,
        SUM(payment_value) AS Revenue
    FROM orders
    JOIN payments
        ON orders.order_id=payments.order_id
    GROUP BY Month
    ORDER BY Month;
    """


def revenue_by_status():
    return """
    SELECT
        order_status,
        SUM(payment_value) AS Revenue
    FROM orders
    JOIN payments
        ON orders.order_id=payments.order_id
    GROUP BY order_status
    ORDER BY Revenue DESC;
    """


def payment_type_orders():
    return """
    SELECT
        payment_type,
        COUNT(*) AS Orders
    FROM payments
    GROUP BY payment_type
    ORDER BY Orders DESC;
    """


# =====================================================
# CUSTOMER ANALYSIS
# =====================================================

def customers_by_state():
    return """
    SELECT
        customer_state,
        COUNT(*) AS Customers
    FROM customers
    GROUP BY customer_state
    ORDER BY Customers DESC;
    """


def top_customer_cities():
    return """
    SELECT
        customer_city,
        COUNT(*) AS Customers
    FROM customers
    GROUP BY customer_city
    ORDER BY Customers DESC
    LIMIT 15;
    """


def customer_growth():
    return """
    SELECT
        strftime('%Y-%m',order_purchase_timestamp) AS Month,
        COUNT(DISTINCT customer_unique_id) AS Customers
    FROM orders
    JOIN customers
        ON orders.customer_id=customers.customer_id
    GROUP BY Month
    ORDER BY Month;
    """


# =====================================================
# PRODUCT ANALYSIS
# =====================================================

def top_categories():
    return """
    SELECT
        p.product_category_name,
        COUNT(*) AS Orders
    FROM order_items oi
    JOIN products p
        ON oi.product_id=p.product_id
    GROUP BY p.product_category_name
    ORDER BY Orders DESC
    LIMIT 15;
    """


def category_revenue():
    return """
    SELECT
        p.product_category_name,
        SUM(oi.price) AS Revenue
    FROM order_items oi
    JOIN products p
        ON oi.product_id=p.product_id
    GROUP BY p.product_category_name
    ORDER BY Revenue DESC
    LIMIT 15;
    """


def product_prices():
    return """
    SELECT
        price
    FROM order_items;
    """


# =====================================================
# SELLER ANALYSIS
# =====================================================

def seller_revenue():
    return """
    SELECT
        seller_id,
        SUM(price) AS Revenue
    FROM order_items
    GROUP BY seller_id
    ORDER BY Revenue DESC
    LIMIT 15;
    """


def seller_orders():
    return """
    SELECT
        seller_id,
        COUNT(order_id) AS Orders
    FROM order_items
    GROUP BY seller_id
    ORDER BY Orders DESC
    LIMIT 15;
    """


def sellers_by_state():
    return """
    SELECT
        seller_state,
        COUNT(*) AS Sellers
    FROM sellers
    GROUP BY seller_state
    ORDER BY Sellers DESC;
    """


# =====================================================
# OPERATIONS
# =====================================================

def delivery_time():
    return """
    SELECT
        AVG(
            julianday(order_delivered_customer_date)
            -
            julianday(order_purchase_timestamp)
        ) AS Delivery_Time
    FROM orders
    WHERE order_delivered_customer_date IS NOT NULL;
    """


def freight_distribution():
    return """
    SELECT
        freight_value
    FROM order_items;
    """


# =====================================================
# CUSTOMER SATISFACTION
# =====================================================

def review_distribution():
    return """
    SELECT
        review_score,
        COUNT(*) AS Reviews
    FROM reviews
    GROUP BY review_score
    ORDER BY review_score;
    """


def average_rating():
    return """
    SELECT
        ROUND(AVG(review_score),2) AS Rating
    FROM reviews;
    """