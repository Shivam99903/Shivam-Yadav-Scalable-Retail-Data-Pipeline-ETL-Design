-- 1. Compute total sales per store (last month)
SELECT
    store_name,
    SUM(price_sold * quantity_sold) AS total_sales_last_month
FROM
    unified_sales_transactions
WHERE
    sale_date >= DATEADD(month, -1, CURRENT_DATE)
    AND sale_date < CURRENT_DATE
GROUP BY
    store_name
ORDER BY
    total_sales_last_month DESC;

-- 2. Identify top 5 selling products
SELECT
    product_name,
    SUM(quantity_sold) AS total_units_sold
FROM
    unified_sales_transactions
GROUP BY
    product_name
ORDER BY
    total_units_sold DESC
LIMIT 5;

-- 3. Flag products with low stock (<10) and propose reorder needs
SELECT
    product_name,
    store_name,
    stock_quantity,
    CASE WHEN stock_quantity < 10 THEN 'REORDER' ELSE 'OK' END AS reorder_flag
FROM
    unified_sales_transactions
WHERE
    stock_quantity < 10
ORDER BY
    product_name, store_name;

-- 4. (Optional) Calculate gross profit per product
SELECT
    t.product_name,
    SUM((t.price_sold - p.cost_price) * t.quantity_sold) AS gross_profit
FROM
    unified_sales_transactions t
    JOIN RAW_PRODUCT p
        ON t.product_id = p.product_id
GROUP BY
    t.product_name
ORDER BY
    gross_profit DESC;
