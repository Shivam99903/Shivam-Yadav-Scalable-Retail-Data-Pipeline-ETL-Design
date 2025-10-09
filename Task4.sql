-- 1. Sales by region
SELECT
    region,
    SUM(price_sold * quantity_sold) AS total_sales
FROM
    unified_sales_transactions
GROUP BY
    region
ORDER BY
    total_sales DESC;

-- 2. Top 3 stores by revenue
SELECT
    store_name,
    SUM(price_sold * quantity_sold) AS total_revenue
FROM
    unified_sales_transactions
GROUP BY
    store_name
ORDER BY
    total_revenue DESC
LIMIT 3;

-- 3. Number of unique products sold per category
SELECT
    category,
    COUNT(DISTINCT PRODUCT_NAME) AS unique_products_sold
FROM
    unified_sales_transactions
GROUP BY
    category
