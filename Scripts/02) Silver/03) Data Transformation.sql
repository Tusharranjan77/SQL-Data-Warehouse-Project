-- Data Transformation in Bronze.crm_cust_info Table --

-- Data Transformation for Primary Key (cst_id) -- 
Select *
From (
		Select *,
		ROW_NUMBER() OVER (Partition by cst_id ORDER BY cst_create_date DESC) as Flag_Last
		From Bronze.crm_cust_info) DT
WHERE Flag_Last = 1
GO
---------------------------------------------------------------------------------------------------------------------
-- Data Transformation and Insertation into Silver Layer --

/*
===============================================================================
Stored Procedure: Load Silver Layer
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'Silver' schema from Bronze Table. 
    It performs the following actions:
    - Truncates the Silver tables before loading data.
    - It Transform and Clean the Bronze Data and Load into Silver Tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

For Execution of Stored Procedure Run This
EXEC Silver.load_silver
===============================================================================
*/

CREATE OR ALTER PROCEDURE Silver.load_silver
AS 
BEGIN
	DECLARE @Start_Time DATETIME , @End_Time DATETIME
	BEGIN TRY
		PRINT'====================================================================================================================='
		PRINT'Loading Silver Layer';
		PRINT'====================================================================================================================='

		PRINT'---------------------------------------------------------------------------------------------------------------------'
		PRINT'Loading CRM Tables'
		PRINT'---------------------------------------------------------------------------------------------------------------------'
		
		SET @Start_Time = GETDATE ();
			PRINT '>> Truncating Table: Silver.crm_cust_info';
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'
			TRUNCATE TABLE Silver.crm_cust_info;
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'

			PRINT '>> Inserting Data into: Silver.crm_cust_info';
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'

			INSERT INTO Silver.crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date)

			Select 
			cst_id,
			cst_key,
			TRIM (cst_firstname) AS cst_firstname,
			TRIM (cst_lastname) AS cst_lastname,

			CASE WHEN UPPER (TRIM (cst_marital_status)) = 'S' THEN 'Single'
				 WHEN UPPER (TRIM (cst_marital_status)) = 'M' THEN 'Married'
				 ELSE 'N/A'
				 END AS cst_marital_status,

			CASE WHEN UPPER (TRIM (cst_gndr)) = 'F' THEN 'Female'
				 WHEN UPPER (TRIM (cst_gndr)) = 'M' THEN 'Male'
				 ELSE 'N/A'
				 END as cst_gndr,
			cst_create_date
			From (
					Select *,
					ROW_NUMBER() OVER (Partition by cst_id ORDER BY cst_create_date DESC) as Flag_Last
					From Bronze.crm_cust_info) DT
			WHERE Flag_Last = 1 AND cst_id IS NOT NULL

			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'
			SET @End_Time = GETDATE();
			PRINT'>> Load Duration: '+ CAST (DATEDIFF(SECOND,@Start_Time,@End_Time) AS NVARCHAR) + 'Seconds';
			PRINT'======================================================================================================================================='

			--------------------------------------------------------------------------------------------------------------
			--------------------------------------------------------------------------------------------------------------
			--------------------------------------------------------------------------------------------------------------
			-- Data Transformation in Bronze.crm_prd_info and Insert into Silver Layer
			PRINT'======================================================================================================================================='
			SET @Start_Time = GETDATE ();
			PRINT '>> Truncating Table: Silver.crm_prd_info';
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'
			TRUNCATE TABLE Silver.crm_prd_info;
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'

			PRINT '>> Inserting Data into: Silver.crm_prd_info';
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'

			INSERT INTO Silver.crm_prd_info (
												prd_id,
												cat_id,
												prd_key,
												prd_nm,
												prd_cost,
												prd_line,
												prd_start_dt,
												prd_end_dt
											)
			Select 
			prd_id,
			REPLACE (SUBSTRING (prd_key,1,5),'-','_') AS cat_id,
			SUBSTRING (prd_key,7,LEN(prd_key)) AS prd_key,
			prd_nm,
			ISNULL (prd_cost,0) AS prd_cost,
			CASE WHEN UPPER (TRIM (prd_line)) = 'M' THEN 'Mountain'
				 WHEN UPPER (TRIM (prd_line)) = 'R' THEN 'Road'
				 WHEN UPPER (TRIM (prd_line)) = 'S' THEN 'Other_Sales'
				 WHEN UPPER (TRIM (prd_line)) = 'T' THEN 'Touring'
				 ELSE 'N/A'
				 END AS prd_line,
			CAST (prd_start_dt AS DATE) AS prd_start_dt,
			CAST (LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) -1 AS DATE) as prd_end
			From Bronze.crm_prd_info

			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'
			SET @End_Time = GETDATE ();
			PRINT 'Load Duration : ' + CAST (DATEDIFF (second,@Start_Time, @End_Time) AS NVARCHAR) + 'Seconds';
			PRINT'======================================================================================================================================='
			------------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------
			PRINT'======================================================================================================================================='

			-- Data Transformation in Bronze.crm_sales_details and Insert into Silver Layer
			SET @Start_Time = GETDATE ();
			PRINT '>> Truncating Table: Silver.crm_sales_details';
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'
			TRUNCATE TABLE Silver.crm_sales_details;
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'

			PRINT '>> Inserting Data into: Silver.crm_sales_details';
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'

			INSERT INTO Silver.crm_sales_details (
														sls_ord_num,
														sls_prd_key,
														sls_cust_id,
														sls_order_dt,
														sls_ship_dt,
														sls_due_dt,
														sls_sales,
														sls_quantity,
														sls_price
												  )

			Select 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
			ELSE CAST (CAST (sls_order_dt AS varchar) AS DATE) -- First Cast as Varchar then as Date -- 
			END as sls_order_dt,

			CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
			ELSE CAST (CAST (sls_ship_dt AS varchar) AS DATE) -- First Cast as Varchar then as Date -- 
			END as sls_ship_dt,

			CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
			ELSE CAST (CAST (sls_due_dt AS varchar) AS DATE) -- First Cast as Varchar then as Date -- 
			END as sls_due_dt,

			CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS (sls_price)
				 THEN sls_quantity * ABS (sls_price)
				 ELSE sls_sales
				 END as sls_sales,

			sls_quantity,

			CASE WHEN sls_price IS NULL OR sls_price <= 0
				 THEN sls_sales / NULLIF (sls_quantity,0)
				 ELSE sls_price
				 END as sls_price
			From Bronze.crm_sales_details

			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'
			SET @End_Time = GETDATE ();
			PRINT 'Load Duration : ' + CAST (DATEDIFF (second,@Start_Time, @End_Time) AS NVARCHAR) + 'Seconds';
			PRINT'======================================================================================================================================='
 
			 ---------------------------------------------------------------------------------------------------------------------------
			 ---------------------------------------------------------------------------------------------------------------------------
			 ---------------------------------------------------------------------------------------------------------------------------
			 PRINT'======================================================================================================================================='
			 -- Data Transformation in Bronze.erp_cust_az12 and Insert into Silver Layer -- 

		PRINT'---------------------------------------------------------------------------------------------------------------------'
		PRINT'Loading ERP Tables'
		PRINT'---------------------------------------------------------------------------------------------------------------------'
		
		PRINT'======================================================================================================================================='
		SET @Start_Time = GETDATE ();
			PRINT '>> Truncating Table: Silver.erp_cust_az12';
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'
			TRUNCATE TABLE Silver.erp_cust_az12;
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'

			PRINT '>> Inserting Data into: Silver.erp_cust_az12';
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'


			 INSERT INTO Silver.erp_cust_az12 (
												cid,
												bdate,
												gen
											   )

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

			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'
			SET @End_Time = GETDATE ();
			PRINT 'Load Duration : ' + CAST (DATEDIFF (second,@Start_Time, @End_Time) AS NVARCHAR) + 'Seconds';
			PRINT'======================================================================================================================================='

			---------------------------------------------------------------------------------------------------------------------------------------------
			---------------------------------------------------------------------------------------------------------------------------------------------
			---------------------------------------------------------------------------------------------------------------------------------------------
			PRINT'======================================================================================================================================='
			-- Data Transformation in Bronze.erp_loc_a101 and Insert into Silver Layer --
			SET @Start_Time = GETDATE ();
			PRINT '>> Truncating Table: Silver.erp_loc_a101';
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'
			TRUNCATE TABLE Silver.erp_loc_a101;
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'

			PRINT '>> Inserting Data into: Silver.erp_loc_a101';
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'

			INSERT INTO Silver.erp_loc_a101 
											(
											  cid,
											  cntry
											)
			Select 
			REPLACE (cid, '-','')AS cid,
			CASE WHEN TRIM (cntry) = 'DE' THEN 'Germany'
				 WHEN TRIM (cntry) IN ('USA','US') THEN 'United States'
				 WHEN TRIM (cntry) = '' OR cntry IS NULL THEN 'N/A'
				 ELSE TRIM (cntry)
				 END as cntry
			From Bronze.erp_loc_a101

			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'
			SET @End_Time = GETDATE ();
			PRINT 'Load Duration : ' + CAST (DATEDIFF (second,@Start_Time, @End_Time) AS NVARCHAR) + 'Seconds';
			PRINT'======================================================================================================================================='


			--------------------------------------------------------------------------------------------------------------------------------------
			--------------------------------------------------------------------------------------------------------------------------------------
			--------------------------------------------------------------------------------------------------------------------------------------
			PRINT'======================================================================================================================================='
			-- Data Transformation  in Bronze.erp_px_cat_g1v2 and Insert into Silver Layer -- 

			SET @Start_Time = GETDATE ();
			PRINT '>> Truncating Table: Silver.erp_px_cat_g1v2';
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'
			TRUNCATE TABLE Silver.erp_px_cat_g1v2;
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'

			PRINT '>> Inserting Data into: Silver.erp_px_cat_g1v2';
			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'

			INSERT INTO Silver.erp_px_cat_g1v2 
												(
												  id,
												  cat,
												  subcat,
												  maintenance
												)
			Select 
			id,
			cat,
			subcat,
			maintenance
			From Bronze.erp_px_cat_g1v2

			PRINT '-------------------------------------------------------------------------------------------------------------------------------------'
			SET @End_Time = GETDATE ();
			PRINT 'Load Duration : ' + CAST (DATEDIFF (second,@Start_Time, @End_Time) AS NVARCHAR) + 'Seconds';
			PRINT'======================================================================================================================================='
			PRINT'Loading Silver Layer is Completed'
			PRINT'======================================================================================================================================='

			-- Data Transfromation has been for all Table and Insertation into Silver Layer has been Completed --
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-----------------------------------------------------------------------------------------------------------------------------------------------
		END TRY 
				BEGIN CATCH
				PRINT '============================================='
				PRINT 'Error Occured During Loading the Bronze Layer'
				PRINT 'Error Message' + ERROR_MESSAGE ();
				PRINT 'Error Message' + CAST (ERROR_NUMBER () AS NVARCHAR);
				PRINT 'Error Message' + CAST (ERROR_STATE () AS NVARCHAR);
				PRINT '============================================='
				END CATCH
END