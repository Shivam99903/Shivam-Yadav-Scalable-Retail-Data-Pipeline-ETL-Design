# Retail Sales Data Pipeline and Reporting Solution

## 📜 Project Goal

This project implements a scalable data pipeline designed to ingest, cleanse, integrate, and transform disparate retail sales data sources (Sales, Inventory, Product, Store) into a **Unified Transaction Layer** within **Snowflake Data Cloud**. The final layer is optimized to support complex analytical queries and business intelligence reporting.

## 🏛️ Architecture and Workflow

The solution follows a multi-layered ETL (Extract, Transform, Load) approach using Python for processing and Snowflake for modern cloud data warehousing.

---

### 1. **Setup and Environment (Configuration & Utilities)**

This section outlines the reusable components necessary for connecting to and interacting with Snowflake.

| File Name | Purpose and Implementation Detail |
| :--- | :--- |
| **`snowflake_creds.yaml`** | **Secure Credential Management.** Stores all necessary Snowflake connection details (`username`, `password`, `account`, `warehouse`, `database`, `schema`) in a secure YAML format. |
| **`utils.py`** | **Reusable Code Library.** Contains modular Python functions, including: <ul><li>`get_snowflake_connection_from_yaml()`: Establishes a connection to Snowflake by securely reading credentials from the YAML file.</li><li>`write_df_to_snowflake_with_mapping()`: A generic function to load Pandas DataFrames into Snowflake tables, handling column name casing/mapping for robust data loading.</li></ul>|
| **`Create_Raw_Layer_Snowflake.ipynb`** | **Schema Initialization.** Connects to Snowflake and executes Data Definition Language (DDL) statements to create the initial **RAW layer tables** (`RAW_PRODUCT`, `RAW_STORE`, `RAW_INVENTORY`, `RAW_SALES_TRANSACTION`) and the target **UNIFIED table** (`unified_sales_transactions`).|

---

### 2. **Raw Data Ingestion and Cleansing (RAW Layer ETL)**

The focus of this stage is to extract data from source files, perform initial cleaning, and load the slightly-transformed data into the Snowflake RAW layer.

| File Name | Process Details |
| :--- | :--- |
| **`Raw_Data_Layer_ETL.ipynb`** | **Core ETL Script (Extraction & Initial Cleaning).** This notebook executes the following steps: <ul><li>**Extraction:** Reads the individual source data files (e.g., `sales.csv`, `inventory.csv`) into Pandas DataFrames.</li><li>**Cleansing & Standardization:** Applies cleaning logic as per case study requirements, including: <ul><li>**Duplicate Removal:** Dropping duplicate rows across all DataFrames.</li><li>**Date Standardization:** Converting date fields (e.g., `sale_date`) to a standard TIMESTAMP format.</li><li>**Text Normalization:** Standardizing text fields (Store Name, Product Name, etc.).</li></ul></li><li>**Loading:** Uses the `write_df_to_snowflake_with_mapping` utility function to load the cleaned DataFrames into their respective tables in the **Snowflake RAW Layer**.</li>|

---

### 3. **Unified Data Transformation (Unified Layer Processing)**

This stage integrates the cleaned tables from the RAW layer into a single, denormalized, and analytics-ready fact table.

| File Name | Process Details |
| :--- | :--- |
| **`vw_unified_sales_transactions.sql`** | **Data Integration View (The JOIN Logic).** This SQL file creates a permanent **VIEW** (`VW_UNIFIED_SALES_TRANSACTIONS`) in Snowflake. This view joins the four RAW tables (`RAW_PRODUCT`, `RAW_STORE`, `RAW_INVENTORY`, `RAW_SALES_TRANSACTION`) to logically connect all data points (product attributes, store location, inventory levels, and transaction details) under a single schema.|
| **`Processing_layer.ipynb`** | **Unified Table Load Logic (ETL).** This notebook executes the final transformation and load step: <ul><li>It uses a standard **Incremental Load** pattern to populate the final target table: `unified_sales_transactions`.</li><li>It selects all records from the joining view (`VW_UNIFIED_SALES_TRANSACTIONS`).</li><li>It inserts new records into the `unified_sales_transactions` table based on a `WHERE NOT EXISTS` clause using the `TRANSACTION_ID`, ensuring **no duplicate transactions** are loaded during subsequent runs.</li></ul>|

---

### 4. **Analytical Reporting (Business Insights)**

With the data successfully integrated into the high-performance `unified_sales_transactions` table, dedicated SQL scripts were developed to derive critical business insights as requested by the case study.

| File Name | Analysis Focus |
| :--- | :--- |
| **`Task_3.sql`** | **Advanced Analytical KPIs.** Focuses on operational and financial health metrics, including: <ul><li>Calculating **total sales per store (last month)** using date functions.</li><li>Identifying **Top 5 selling products** by total units sold.</li><li>Applying a conditional flag (`REORDER` / `OK`) to identify products with **low stock (\<10)** for replenishment planning.</li></ul> |
| **`Task4.sql`** | **Strategic Aggregation Reports.** Focuses on high-level business performance, including: <ul><li>Aggregating **Sales by Region**.</li><li>Identifying the **Top 3 stores by total revenue**.</li><li>Calculating the **Number of unique products sold per category**.</li></ul> |

---

## 🛠️ Technology Stack

| Category | Tools / Technologies |
| :--- | :--- |
| **Data Warehousing** | **Snowflake Data Cloud** (Used for all persistence layers: RAW, Unified, Views, and final analysis) |
| **ETL/Processing** | **Python (Pandas)** (For data reading, cleaning, and initial DataFrame manipulation) |
| **Orchestration/Connectors**| **`snowflake-connector-python`**, **YAML** (For secure credentials) |
| **Transformation** | **SQL** (Snowflake T-SQL for view creation, incremental loads, and advanced aggregation) |