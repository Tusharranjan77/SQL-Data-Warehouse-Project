 /* Get the Data from Bronze Layer for Each Table and Analyse 
 and Explore one by one 
 Expectation : No Quality Issue */

 -- Getting the Bronze.crm_cust_info Data --
 Select *
 From Bronze.crm_cust_info

 -- Check for Duplicates in the Primary Key --

 Select 
 cst_id,
 COUNT (*) as DuplicateCounts
 From Bronze.crm_cust_info
 GROUP BY cst_id
 HAVING   COUNT (*) > 1 or cst_id IS NULL

 -- Check for Null in the Primary Key --
SELECT *
FROM Bronze.crm_cust_info
WHERE cst_id IS NULL;

-- Check for Unwanted Spaces in ALL String Values --
-- Expectation : No Result (If Result is Coming there is an Issue)

Select 
cst_key
From Bronze.crm_cust_info
WHERE cst_key != TRIM (cst_key)
GO

Select 
cst_firstname
From Bronze.crm_cust_info
WHERE cst_firstname != TRIM (cst_firstname)
GO

Select 
cst_lastname
From Bronze.crm_cust_info
WHERE cst_lastname != TRIM (cst_lastname)
GO

Select 
cst_marital_status
From Bronze.crm_cust_info
WHERE cst_marital_status != TRIM (cst_marital_status)
GO

Select 
cst_gndr
From Bronze.crm_cust_info
WHERE cst_gndr != TRIM (cst_gndr)
GO

-- Check the Data Standardization and consistency of values in low cardinality columns (column : MaritalStatus and Gender) -- 
Select DISTINCT
cst_gndr
From Bronze.crm_cust_info
-- Replacing M with Male , F With Female and NULL with Not Available -- 

Select DISTINCT
cst_marital_status
From Bronze.crm_cust_info
-- Replacing S with Single, M with Married and NULL with Not Available -- 

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

-- Now Explore Each Table of Bronze Layer One by One and Do Data Transformation --

-- Getting the Bronze.crm_prd_info Data --
 Select *
 From Bronze.crm_prd_info
-----------------------------------------------------------------------------------------------

-- Check for Duplicates in the Primary Key --
-- Expectation : No Result --
 Select 
 prd_id,
 COUNT (*) as DuplicateCounts
 From Bronze.crm_prd_info
 GROUP BY prd_id
 HAVING   COUNT (*) > 1 or prd_id IS NULL
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
/*  Deriving Value From prd_key to join or make a relationship 
with another table AND Making consistent with another table Primary ID */

Select 
REPLACE (SUBSTRING (prd_key,1,5),'-','_') AS cat_id , -- Used to Join With (Bronze.erp_px_cat_g1v2) and  Replace is used to make ID Consistent -- 
SUBSTRING (prd_key,7,LEN(prd_key)) AS prd_key -- Used to Join With (Bronze.crm_sales_details) 
From Bronze.crm_prd_info

-- Check another table for joing the data --
Select DISTINCT
id
From Bronze.erp_px_cat_g1v2

Select 
sls_prd_key
From Bronze.crm_sales_details

-------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

-- Check for Unwanted Spaces in prd_nm --
-- Expectation : No Result (If Result is Coming there is an Issue)

Select 
prd_nm
From Bronze.crm_prd_info
WHERE prd_nm != TRIM (prd_nm)
GO

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

-- Check for NULLS and Negative Numbers in prd_cost -- AND Replacing NULL with 0 -- 
-- Expectation : No Result --

Select 
ISNULL (prd_cost,0) AS prd_cost
From Bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL
GO

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- Check the Data Standardization and consistency of values in low cardinality columns --

Select DISTINCT
prd_line
From Bronze.crm_prd_info
/* Replacing M with Mountain , R With Road, S With Other Sales , T with Touring 
and NULL with Not Available  */

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- Check Invalid Dates in prd_start_dt and prd_end_dt --

Select *
From Bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt

Select 
prd_id,
prd_key,
prd_nm,
prd_start_dt,
prd_end_dt,
LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) -1 as prd_end_dt_Test_Start_Date
From Bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509') 

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

-- Getting the Data From Bronze.crm_sales_details --

Select *
From Bronze.crm_sales_details
--------------------------------------------------------------------------------------------------------------------
-- Checking Issues in sls_ord_num --

Select 
sls_ord_num
From Bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

Select 
sls_prd_key
From Bronze.crm_sales_details
WHERE sls_prd_key NOT IN (
							Select 
							prd_key
							From Silver.crm_prd_info

						 )
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

Select 
sls_cust_id
From Bronze.crm_sales_details
WHERE sls_cust_id NOT IN (
							Select 
							cst_id
							From Silver.crm_cust_info

						 )
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
-- Check for Invalid Dates -- (sls_order_dt , sls_ship_dt , sls_due_dt)
Select 
NULLIF (sls_order_dt,0) AS sls_order_dt
From Bronze.crm_sales_details
WHERE sls_order_dt < 0 
OR sls_order_dt = 0
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101 -- (Boundary Date) (End Date)
OR sls_order_dt < 19000101 -- (Boundary Date) (Start Date)

Select 
NULLIF (sls_ship_dt,0) AS sls_ship_dt
From Bronze.crm_sales_details
WHERE sls_ship_dt < 0 
OR sls_ship_dt = 0
OR LEN(sls_ship_dt) != 8
OR sls_ship_dt > 20500101 -- (Boundary Date) (End Date)
OR sls_ship_dt < 19000101 -- (Boundary Date) (Start Date)

Select 
NULLIF (sls_due_dt,0) AS sls_due_dt
From Bronze.crm_sales_details
WHERE sls_due_dt < 0 
OR sls_due_dt = 0
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101 -- (Boundary Date) (End Date)
OR sls_due_dt < 19000101 -- (Boundary Date) (Start Date)

Select *
From Bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt  OR  sls_order_dt > sls_due_dt 

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

-- Check sls_sales , sls_quantity , sls_price -- and Transform Them -- 

Select DISTINCT
sls_sales as old_sls_sales,
sls_quantity,
sls_price as old_sls_price,

CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS (sls_price)
     THEN sls_quantity * ABS (sls_price)
	 ELSE sls_sales
	 END as sls_sales,

CASE WHEN sls_price IS NULL OR sls_price <= 0
	 THEN sls_sales / NULLIF (sls_quantity,0)
	 ELSE sls_price
	 END as sls_price

From Bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0  OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

-- Getting Data from Bronze.erp_cust_az12 -- 

Select *
From Bronze.erp_cust_az12
-------------------------------------------------------------------------------------------------------------------------

Select
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING (cid, 4, LEN (cid))
	 ELSE cid
	 END as cid,

CASE WHEN bdate > GETDATE () THEN NULL
	 ELSE bdate
	 END as bdate,

CASE WHEN UPPER(TRIM (gen)) IN ('F','FEMALE') THEN 'Female'
	 WHEN UPPER(TRIM (gen)) IN ('M','MALE') THEN 'Male'
	 ELSE 'N/A'
	 END as gen

From Bronze.erp_cust_az12

-- Data Standardization and Consistency -- 
Select DISTINCT
gen
From Bronze.erp_cust_az12


--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

-- Getting Data From Bronze.erp_loc_a101 -- 

Select *
From Bronze.erp_loc_a101
----------------------------------------------------------------------------------------------------------------------------------------

Select 
REPLACE (cid, '-','')AS cid,
CASE WHEN TRIM (cntry) = 'DE' THEN 'Germany'
	 WHEN TRIM (cntry) IN ('USA','US') THEN 'United States'
	 WHEN TRIM (cntry) = '' OR cntry IS NULL THEN 'N/A'
	 ELSE TRIM (cntry)
	 END as cntry
From Bronze.erp_loc_a101
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

-- Data Standardization and Consistency --
Select DISTINCT
cntry
From Bronze.erp_loc_a101


--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

-- Getting Data from Bronze.erp_px_cat_g1v2 -- 

Select *
From Bronze.erp_px_cat_g1v2

----------------------------------------------------------------------------------------------------------------------------------------
Select 
id,
cat,
subcat,
maintenance
From Bronze.erp_px_cat_g1v2

-- Check for Unwanted Space --
Select 
cat
From Bronze.erp_px_cat_g1v2
WHERE cat != TRIM (cat)

----------------------------------------------------------------------------------------------------------------------------------------
Select 
subcat
From Bronze.erp_px_cat_g1v2
WHERE subcat != TRIM (subcat)
------------------------------------------------------------------------------------------------------------------------------------------
Select 
maintenance
From Bronze.erp_px_cat_g1v2
WHERE maintenance != TRIM (maintenance)

------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

-- Data Standardization and Consistency -- 
Select DISTINCT
maintenance
From Bronze.erp_px_cat_g1v2



