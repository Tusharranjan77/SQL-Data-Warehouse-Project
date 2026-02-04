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

-- Creating a Gold Layer of Product Dimension Table but in the form  of Virtable Table --
-- Doing Data Integration and Data Enrichment if Needed -- 
-- Joing Different Tables with Respective key to make a Relationship among these table -- (Get Respective Data and Columns)
-- Creating a Surroagte key using Windows Function (Row_Number) --
-- Creating a VIEW at Last to Store the Table Virtually --

	CREATE OR ALTER VIEW Gold.dim_products AS
	Select 
			ROW_NUMBER () OVER (ORDER BY PI.prd_start_dt,PI.prd_key) as Product_Key,
			PI.prd_id as Product_ID,
			PI.prd_key as Product_Number,
			PI.prd_nm as Product_Name,
			PI.cat_id as CategoryID,
			PC.cat as Category,
			PC.subcat as Sub_Category,
			PC.maintenance as Maintenance,
			PI.prd_cost as Product_Cost,
			PI.prd_line as Product_Line,
			PI.prd_start_dt as Start_Date
	From Silver.crm_prd_info as PI
	LEFT JOIN [Silver].erp_px_cat_g1v2 as PC ON PI.cat_id = PC.id
	WHERE PI.prd_end_dt IS NULL -- Filter out the old data -- 
