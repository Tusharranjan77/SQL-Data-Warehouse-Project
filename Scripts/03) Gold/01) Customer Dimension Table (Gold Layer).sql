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

-- Creating a Gold Layer of Customer Dimension Table but in the form  of Virtable Table --
-- Doing Data Integration and Data Enrichment if Needed -- (Like we did for Gender Column)
-- Joing Different Tables with Respective key to make a Relationship among these table -- (Get Respective Data and Columns)
-- Creating a Surroagte key using Windows Function (Row_Number) --
-- Creating a VIEW at Last to Store the Table Virtually --


CREATE OR ALTER VIEW Gold.dim_customers AS
Select 
		ROW_NUMBER () OVER (ORDER BY CI.cst_id) as Customer_Key,
		CI.cst_id as Customer_ID,
		CI.cst_key as Customer_Number,
		CI.cst_firstname as First_Name,
		CI.cst_lastname as Last_Name,
		CL.cntry as Country,
		CI.cst_marital_status as Marital_Status,
		CASE WHEN CI.cst_gndr != 'N/A' THEN CI.cst_gndr
		ELSE CA.gen
		END  as Gender,
		CA.bdate as Birth_Date,
		CI.cst_create_date as Create_Date
From Silver.crm_cust_info as CI
LEFT JOIN [Silver].erp_cust_az12 as CA ON CI.cst_key = CA.cid
LEFT JOIN [Silver].erp_loc_a101 AS CL ON CI.cst_key = CL.cid

