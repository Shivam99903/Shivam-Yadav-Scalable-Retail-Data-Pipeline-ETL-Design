
-- Filename: vw_unified_sales_transactions.sql
-- Purpose : Create a robust unified sales transactions view in Snowflake
-- Notes   :
--  - Preserves LEFT JOIN semantics by keeping filters out of WHERE on right table
--  - Joins sales on both PRODUCT_ID and STORE_ID to avoid cross-store mismatches
--  - Use fully-qualified names if objects are in a different database/schema

CREATE OR REPLACE VIEW SNOWFLAKE_LEARNING_DB.PUBLIC.VW_UNIFIED_SALES_TRANSACTIONS AS
SELECT
    p.PRODUCT_ID          AS product_id,
    p.PRODUCT_NAME        AS product_name,
    p.CATEGORY            AS category,
    i.STORE_ID            AS store_id,
    st.STORE_NAME         AS store_name,
    st.CITY               AS city,
    st.REGION             AS region,
    s.TRANSACTION_ID      AS transaction_id,
    s.QUANTITY_SOLD       AS quantity_sold,
    s.PRICE_SOLD          AS price_sold,
    i.STOCK_QUANTITY      AS stock_quantity,
    s.SALE_DATE           AS sale_date
FROM SNOWFLAKE_LEARNING_DB.PUBLIC.RAW_PRODUCT               AS p
JOIN SNOWFLAKE_LEARNING_DB.PUBLIC.RAW_INVENTORY             AS i
  ON p.PRODUCT_ID = i.PRODUCT_ID
JOIN SNOWFLAKE_LEARNING_DB.PUBLIC.RAW_STORE                 AS st
  ON i.STORE_ID = st.STORE_ID
LEFT JOIN SNOWFLAKE_LEARNING_DB.PUBLIC.RAW_SALES_TRANSACTION AS s
  ON s.PRODUCT_ID = p.PRODUCT_ID
 AND s.STORE_ID   = i.STORE_ID
WHERE p.PRODUCT_ID IS NOT NULL;
