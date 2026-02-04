# 📊 SQL Data Warehouse – Gold Layer Data Catalog

## Overview
The **Gold Layer** represents the **business-consumption layer** of the SQL Data Warehouse.  
It contains **curated, analytics-ready datasets** designed to support reporting, dashboards, and decision-making.

Data in this layer is:
- Cleaned and standardized
- Enriched with business logic
- Modeled using **dimensional modeling (Star Schema)** principles
- Optimized for **analytical queries and BI tools**

---

## 🏗️ Gold Layer Tables

### 1️⃣ `gold.dim_customers`

#### Purpose
Stores **customer master data** enriched with demographic and geographic attributes.  
This table enables customer-level analysis such as segmentation, lifetime value analysis, and sales trend reporting.

#### Schema
| Column Name | Data Type | Description |
|------------|----------|-------------|
| `customer_key` | INT | Surrogate key uniquely identifying each customer record in the dimension table. |
| `customer_id` | INT | Business (natural) key representing the customer identifier from the source system. |
| `customer_number` | NVARCHAR(50) | Alphanumeric customer reference code used for tracking and external identification. |
| `first_name` | NVARCHAR(50) | Customer’s first name as recorded in the source system. |
| `last_name` | NVARCHAR(50) | Customer’s last or family name. |
| `country` | NVARCHAR(50) | Country of residence of the customer (e.g., Australia). |
| `marital_status` | NVARCHAR(50) | Customer’s marital status (e.g., Married, Single). |
| `gender` | NVARCHAR(50) | Gender of the customer (e.g., Male, Female, n/a). |
| `birthdate` | DATE | Customer’s date of birth in YYYY-MM-DD format. |
| `create_date` | DATE | Date when the customer record was first created in the system. |

---

### 2️⃣ `gold.dim_products`

#### Purpose
Contains **product master data** along with classification, cost, and lifecycle attributes.  
This dimension supports product-level performance analysis, profitability tracking, and category-based reporting.

#### Schema
| Column Name | Data Type | Description |
|------------|----------|-------------|
| `product_key` | INT | Surrogate key uniquely identifying each product record in the dimension table. |
| `product_id` | INT | Business (natural) key representing the product identifier from the source system. |
| `product_number` | NVARCHAR(50) | Structured alphanumeric product code used for inventory and classification. |
| `product_name` | NVARCHAR(50) | Descriptive name of the product including attributes such as type, color, or size. |
| `category_id` | NVARCHAR(50) | Identifier representing the product’s high-level category. |
| `category` | NVARCHAR(50) | Broad product classification (e.g., Bikes, Components). |
| `subcategory` | NVARCHAR(50) | Detailed classification within the product category. |
| `maintenance_required` | NVARCHAR(50) | Indicates whether the product requires maintenance (Yes/No). |
| `cost` | INT | Base cost of the product in whole currency units. |
| `product_line` | NVARCHAR(50) | Product line or series (e.g., Road, Mountain). |
| `start_date` | DATE | Date when the product became available for sale. |

---

### 3️⃣ `gold.fact_sales`

#### Purpose
Stores **transactional sales data** at the line-item level.  
This fact table acts as the **core analytical table** for revenue, pricing, quantity, and time-based analysis.

#### Schema
| Column Name | Data Type | Description |
|------------|----------|-------------|
| `order_number` | NVARCHAR(50) | Unique sales order identifier (e.g., SO54496). |
| `product_key` | INT | Foreign key referencing `gold.dim_products`. |
| `customer_key` | INT | Foreign key referencing `gold.dim_customers`. |
| `order_date` | DATE | Date when the sales order was placed. |
| `shipping_date` | DATE | Date when the order was shipped to the customer. |
| `due_date` | DATE | Date by which payment for the order is due. |
| `sales_amount` | INT | Total monetary value of the sales line item in whole currency units. |
| `quantity` | INT | Number of product units sold in the line item. |
| `price` | INT | Unit price of the product at the time of sale. |

---

## 🔗 Data Modeling Design

- The Gold Layer follows a **Star Schema** architecture.
- Dimension tables:
  - `gold.dim_customers`
  - `gold.dim_products`
- Fact table:
  - `gold.fact_sales`
- Relationships are established using **surrogate keys** to ensure:
  - High query performance
  - Simplified analytical joins
  - Scalability for large datasets

---

## 📈 Use Cases Supported
- Sales performance analysis
- Customer segmentation and behavior analysis
- Product profitability reporting
- Time-based revenue and demand trends
- BI dashboarding (Power BI, Tableau, etc.)

---

## 🚀 Tech Stack
- SQL (Data Warehouse Modeling)
- Dimensional Modeling (Kimball-style)
- Designed for BI & Analytics workloads

---

## 📌 Notes
This data catalog is part of a **multi-layer SQL Data Warehouse architecture** (Bronze → Silver → Gold), where the Gold Layer represents the final, business-ready output.

---

**Author:** *[Tushar Ranjan]*  
**Project Type:** SQL Data Warehouse / Analytics Engineering  
