# Modern-Data-Warehouse-Project-SQL-Server

# 🏗️ Modern Data Warehouse Project | SQL Server

## 📌 Project Overview

This project demonstrates how I built a modern data warehouse using **Microsoft SQL Server**, following the Medallion Architecture: Bronze, Silver, and Gold.

The main goal of this project is to take raw data from CRM and ERP source systems, clean and integrate it, and organize it into a business-ready dimensional model that can support reporting and analytics.

I focused on data quality, SQL transformations, data integration, and designing a structure that can be used for business intelligence tools such as Power BI.

## 🎯 Project Objectives

- 📥 Load raw data from CRM and ERP CSV files into SQL Server.
- 🥉 Create a Bronze layer to store raw source data.
- 🥈 Build a Silver layer to clean, standardize, and validate the data.
- 🥇 Create a Gold layer with customer and product dimensions and a sales fact view.
- 🔍 Perform data quality checks to identify missing values, duplicates, and invalid records.
- 🔗 Integrate information from multiple source systems.
- 📊 Prepare business-ready data for reporting and analytical queries.
- 📝 Document the warehouse structure, transformations, and data flow.

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Microsoft SQL Server | Database and data warehouse development |
| SQL | Data transformation, validation, joins, and analytical modeling |
| T-SQL | Stored procedures, views, window functions, and data loading |
| CSV Files | Source data from CRM and ERP systems |
| Git & GitHub | Version control and project documentation |
| Power BI | Potential downstream reporting and visualization |

## 🏛️ Architecture

The project follows the **Medallion Architecture**.

```text
           📂 CRM & ERP Source Files
                    │
                    ▼
          🥉 BRONZE LAYER
       Raw data ingestion from CSV
                    │
                    ▼
           🥈 SILVER LAYER
     Cleaning • Standardization
       Validation • Integration
                    │
                    ▼
             🥇 GOLD LAYER
       Business-ready data model
                    │
          ┌─────────┼─────────┐
          ▼         ▼         ▼
      Customers  Products   Sales
       Dimension Dimension   Fact
                    │
                    ▼
             📊 BI & Analytics
```

## 🥉 1. Bronze Layer — Raw Data Ingestion

The Bronze layer is the starting point of the data warehouse. I created the database structure and stored the source data from CRM and ERP CSV files in raw tables.

### 🔧 What I implemented

- Created the `DataWarehouse` database.
- Created separate schemas for Bronze, Silver, and Gold.
- Created raw tables for CRM and ERP datasets.
- Used `BULK INSERT` to load data from CSV files.
- Developed the stored procedure `bronze.load_bronze` to organize the loading process.
- Used `TRUNCATE TABLE` before loading to replace the existing data during a reload.
- Checked row counts after loading to verify that the data was imported.

### 📂 Bronze schema

**CRM tables**
- `bronze.crm_cust_info`
- `bronze.crm_prd_info`
- `bronze.crm_sales_details`

**ERP tables**
- `bronze.erp_cust_az12`
- `bronze.erp_loc_a101`
- `bronze.erp_px_cat_g1v2`

### 💡 Key learning

I learned how to ingest multiple source files into SQL Server and organize raw data before applying any business transformations.

## 🥈 2. Silver Layer — Data Cleaning and Transformation

The Silver layer converts raw source data into cleaner, more consistent, and reliable data.

Before transforming the data, I performed quality checks to identify common data problems such as duplicate keys, missing values, invalid dates, and inconsistent text values.

### 🔍 Data quality checks

- Checked for NULL values and duplicate customer or product identifiers.
- Identified unwanted spaces in text columns.
- Checked product costs for missing or negative values.
- Reviewed product line values and date ranges.
- Validated customer, product, and sales-related data before loading the cleaned results.

### 🧹 CRM data transformations

**Customer data — `silver.crm_cust_info`**
- Removed unwanted spaces from customer names.
- Standardized gender and marital status values.
- Removed records with missing customer identifiers.
- Used `ROW_NUMBER()` to identify duplicate customer records and retain the selected latest record based on the creation date.

**Product data — `silver.crm_prd_info`**
- Cleaned and standardized product information.
- Handled missing product costs using a default value where required.
- Standardized product line descriptions.
- Converted product start and end dates into date values.
- Used the `LEAD()` window function to derive product end dates from the next product start date.

**Sales data — `silver.crm_sales_details`**
- Prepared sales details for integration with customer and product information.
- Validated sales-related values and dates according to the transformation rules.

### 🔗 ERP data transformations

I also prepared the ERP datasets for integration with the CRM data.

- **`silver.erp_cust_az12`** — cleaned customer-related information, including identifiers and birth dates according to the source data rules.
- **`silver.erp_loc_a101`** — standardized customer identifiers and location or country codes.
- **`silver.erp_px_cat_g1v2`** — prepared product category information and related attributes.

### ✅ Validation

After loading the Silver layer, I checked the transformed data to make sure the cleaning rules were applied correctly and the data was ready for the next layer.

### 💡 Key learning

This stage helped me understand that data cleaning is not just about removing NULL values. It also involves understanding business rules, resolving duplicates, standardizing formats, and maintaining consistency across source systems.

## 🥇 3. Gold Layer — Business-Ready Data Model

The Gold layer provides a business-oriented structure that makes the cleaned data easier to use for reporting and analytics.

I created three main views to represent the dimensional model: a customer dimension, a product dimension, and a sales fact view.

### 👥 Customer Dimension — `gold.dim_customers`

This view combines customer information from the cleaned CRM and ERP datasets.

**Key operations**
- Combined CRM customer details with ERP customer information.
- Integrated location information.
- Used `LEFT JOIN` to retain CRM customer records even when matching ERP information was unavailable.
- Applied logic to select the available gender value from the appropriate source.
- Included customer attributes such as name, gender, marital status, birth date, and location.
- Generated a customer key using `ROW_NUMBER()`.

**Business purpose:** Provides a consistent customer view for customer analysis and sales reporting.

### 📦 Product Dimension — `gold.dim_products`

This view combines CRM product information with ERP product category details.

**Key operations**
- Integrated product information with category information.
- Used `LEFT JOIN` to combine the cleaned datasets.
- Retained current product records using the product end-date condition.
- Generated a product key using `ROW_NUMBER()`.
- Organized product attributes for use in sales analysis.

**Business purpose:** Helps analyze sales by product, category, and product-related attributes.

### 💰 Sales Fact View — `gold.fact_sales`

This view connects sales transactions with the customer and product dimensions.

**Key operations**
- Used cleaned CRM sales details as the transaction source.
- Joined sales records with the customer and product dimensions.
- Included order number, customer key, product key, order date, shipping date, due date, sales amount, quantity, and price.

**Business purpose:** Provides the central dataset for analyzing sales performance and transaction-level activity.

### ⭐ Why I used a dimensional model

A dimensional model separates descriptive information from transactional data.

- **Dimensions** describe customers and products.
- **Fact data** records sales transactions and their measurable values.
- **Keys** connect sales records to the corresponding customer and product information.

This structure is suitable for analytical queries and can be used as a foundation for Power BI reports.

> **Note:** The Gold objects in this project are views, so the dimensional model is implemented through SQL views rather than physically stored Gold tables.

## 🔄 Data Loading Strategy

I organized the workflow into three stages:

1. **Bronze:** Load the source CSV files into raw tables.
2. **Silver:** Clean, standardize, transform, and validate the source data.
3. **Gold:** Create views that combine the cleaned data into a business-ready model.

The Bronze loading procedure uses a full reload approach by truncating existing data before importing it again. The project uses a latest-dataset approach and does not implement historical tracking or Slowly Changing Dimensions.

## 📁 Project Structure

```text
data-warehouse-project/
│
├── datasets/
│   ├── crm/
│   └── erp/
│
├── scripts/
│   ├── init_database.sql
│   ├── bronze/
│   │   ├── ddl_bronze.sql
│   │   └── proc_load_bronze.sql
│   │
│   ├── silver/
│   │   ├── ddl_silver.sql
│   │   └── proc_load_silver.sql
│   │
│   └── gold/
│       └── gold_views.sql
│
├── docs/
│   └── data_architecture.png
│
└── README.md
```

*Note: This is a suggested repository structure. Keep only the folders and filenames that actually exist in your GitHub repository, and adjust the names to match your SQL scripts.*

## 🧪 Skills Demonstrated

- SQL Server database development
- T-SQL programming
- Stored procedures and data loading
- `BULK INSERT` for CSV ingestion
- Data quality checks and validation
- Data cleaning and standardization
- `CASE`, `COALESCE`, `LEFT JOIN`, and date functions
- Window functions such as `ROW_NUMBER()` and `LEAD()`
- Medallion Architecture
- Dimensional modeling
- Fact and dimension view design
- Data warehouse documentation

## ⚠️ Current Scope and Limitations

- The project uses a full-reload approach rather than incremental loading.
- Historical changes are not maintained.
- Surrogate keys generated using `ROW_NUMBER()` are suitable for this simplified project but are not guaranteed to remain stable when the underlying data changes.
- The Gold layer is implemented using views rather than materialized tables.
- The final reporting layer can be connected to Power BI for further visualization and business analysis.

## 🚀 Future Improvements

- Add incremental data loading.
- Implement Slowly Changing Dimensions (SCD Type 2) to preserve historical changes.
- Add automated data quality checks and logging.
- Introduce error handling and load audit tables.
- Build a Power BI dashboard on top of the Gold views.
- Add a star schema diagram and sample business SQL queries.
- Automate the end-to-end loading process.

## 📚 What I Learned

Through this project, I gained practical experience in building a SQL Server data warehouse from the ground up. I learned how to ingest raw data, identify data quality issues, apply cleaning rules, integrate CRM and ERP sources, and organize the results into a dimensional model.

The most important lesson was understanding how raw operational data can be transformed into structured information that supports business reporting and decision-making.

## 👨‍💻 Author

**Ammuturi Manikanta**

M.Sc. Data Science Student | Aspiring Data Analyst / BI Developer

**Technical interests:** SQL, Power BI, Data Analytics, and Data Warehousing

🔗 GitHub: [Manikanta13226](https://github.com/Manikanta13226)

---

⭐ If you find this project useful, feel free to explore the repository and share your feedback.
