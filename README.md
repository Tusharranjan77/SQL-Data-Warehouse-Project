# SQL Data Warehouse Project

## Project Overview
This project demonstrates the design and implementation of a **modern Data Warehouse** using **SQL Server**.  
The objective is to consolidate raw sales data into a structured, analytical data model that supports **reporting, analytics, and informed business decision-making**.

The project follows a **Medallion Architecture (Bronze → Silver → Gold)** and implements end-to-end data warehousing concepts including **data ingestion, transformation, optimization, and modeling** using SQL.

---

## Objective of the Project
- Develop a scalable and maintainable **Data Warehouse using SQL Server**
- Consolidate sales data from raw sources
- Enable analytical reporting and business insights
- Apply real-world **ETL / ELT concepts** using SQL only

---

## Data Architecture
- **Architecture Type:** Data Warehouse
- **Approach:** Medallion Architecture
- **Layers:** Bronze → Silver → Gold

---

## Extraction Details

### Extraction Method
- **Pull-based extraction**
- Data is pulled from source files into the warehouse

### Extraction Type
- **Full Extraction** (No incremental extraction)

### Extraction Techniques
- **File Parsing**

---

## Transformation Details

### Transformation Techniques
The project includes comprehensive transformation logic such as:

- **Data Enrichment**
- **Data Integration**
- **Derived Columns**
- **Data Normalization & Standardization**
- **Business Rules & Business Logic**
- **Data Aggregation**

### Data Cleaning Techniques
- Removing duplicate records
- Data filtering
- Handling missing data
- Handling invalid values
- Removing unwanted spaces
- Data type casting
- Outlier detection

---

## Load Details

### Load Type
- **Batch Processing**
- Streaming is intentionally not used

### Load Method
- **Full Load using Truncate & Insert**
- Incremental load is not used

### Slowly Changing Dimension (SCD)
- **SCD Type 1** (Overwrite strategy)

---

## Medallion Architecture Layers

### 🟤 Bronze Layer – Raw Data
**Purpose:** Traceability and debugging

- **Object Type:** Tables
- **Load Method:** Full Load (Truncate & Insert)
- **Transformations:** None
- **Data Modeling:** None
- **Target Audience:** Data Engineers
- **Coding Focus:** Data Ingestion
- **Validation Checks:**
  - Data completeness
  - Schema validation

---

### ⚪ Silver Layer – Clean & Standardized Data
**Purpose:** Prepare data for analysis

- **Object Type:** Tables
- **Load Method:** Full Load (Truncate & Insert)
- **Transformations:**
  - Data cleaning
  - Data standardization
  - Data normalization
  - Derived columns
  - Data enrichment
- **Data Modeling:** None
- **Target Audience:** Data Engineers, Data Analysts
- **Coding Focus:** Data Cleaning & Transformation
- **Validation Checks:**
  - Data correctness checks

---

### 🟡 Gold Layer – Business-Ready Data
**Purpose:** Enable reporting and analytics

- **Object Type:** Views
- **Load Method:** Not applicable
- **Transformations:**
  - Data integration
  - Data aggregation
  - Business logic and rules
- **Data Modeling:**
  - Star schema
  - Aggregated objects
  - Flat tables
- **Target Audience:** Data Analysts, Business Users
- **Coding Focus:** Data Integration
- **Validation Checks:**
  - Data integration checks

---

## Performance Optimization
- Indexes are applied where required
- Table partitioning is used if needed for performance improvement

---

## Naming Conventions
- **PascalCase** is used consistently
- Naming format:
  - `SchemaNameTableName`
  - Example: `SalesCustomer`
    - `Sales` → Schema
    - `Customer` → Table

---

## Technologies Used
- SQL Server
- SQL (DDL, DML, analytical queries)

---

## Key Learnings from the Project
- End-to-end Data Warehouse design
- Medallion architecture implementation
- SQL-based ETL logic
- Data quality and validation techniques
- Performance optimization using indexes and partitions
- Dimensional modeling concepts

---

## Conclusion
This project represents a real-world **Data Warehouse implementation using SQL Server**, focusing on clean architecture, robust transformations, and analytics-ready data. It is designed to reflect industry-standard data engineering practices using SQL.

