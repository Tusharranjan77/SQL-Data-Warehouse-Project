/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- Creating a Gold Layer of Sales Fact Table but in the form  of Virtable Table --
-- Doing Data Integration and Data Enrichment if Needed -- 
-- Joing Different Tables with Respective key to make a Relationship among these table -- (Joining Gold Tables)
-- Creating a VIEW at Last to Store the Table Virtually --


CREATE OR ALTER VIEW Gold.fact_sales AS
Select 
PR.Product_Key,
CS.Customer_Key,
SD.sls_ord_num as Order_Number,
SD.sls_order_dt as Order_Date,
SD.sls_ship_dt as Shipping_Date,
SD.sls_due_dt as Due_Date,
SD.sls_quantity as Quantity,
SD.sls_price as Price,
SD.sls_sales as Total_Sales
From Silver.crm_sales_details as SD
LEFT JOIN [Gold].dim_products as PR ON PR.Product_Number = SD.sls_prd_key
LEFT JOIN [Gold].dim_customers as CS ON CS.Customer_ID = SD.sls_cust_id
