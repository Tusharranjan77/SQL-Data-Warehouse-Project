 -- Quality Check for Duplicates in the Primary Key --

 Select 
 prd_id,
 COUNT (*) as DuplicateCounts
 From Silver.crm_prd_info
 GROUP BY prd_id
 HAVING   COUNT (*) > 1 or prd_id IS NULL

 -- Check for Null in the Primary Key --
SELECT *
FROM Silver.crm_prd_info
WHERE prd_id IS NULL;

-- Check for Unwanted Spaces in ALL String Values --
-- Expectation : No Result (If Result is Coming there is an Issue)

Select 
prd_nm
From Silver.crm_prd_info
WHERE prd_nm != TRIM (prd_nm)
GO

Select 
cst_firstname
From Silver.crm_cust_info
WHERE cst_firstname != TRIM (cst_firstname)
GO

Select 
cst_lastname
From Silver.crm_cust_info
WHERE cst_lastname != TRIM (cst_lastname)
GO

Select 
cst_marital_status
From Silver.crm_cust_info
WHERE cst_marital_status != TRIM (cst_marital_status)
GO

Select 
cst_gndr
From Silver.crm_cust_info
WHERE cst_gndr != TRIM (cst_gndr)
GO

-- Check the Date Standardization and consistency of values in low cardinality columns (column : MaritalStatus and Gender) -- 
Select DISTINCT
cst_gndr
From Silver.crm_cust_info
-- Replacing M with Male , F With Female and NULL with Not Available -- 


Select DISTINCT
prd_line
From Silver.crm_prd_info
-- Replacing S with Single, M with Married and NULL with Not Available -- 

-- Checking Productioin Cost --
Select 
prd_cost
From Silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL


Select *
From Silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt



Select 
sls_sales,
sls_quantity,
sls_price
From Silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0  OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

Select *
From Silver.crm_sales_details