
/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

For Execution of Stored Procedure Run This
EXEC Bronze.load_bronze
===============================================================================
*/



/* Create a Stored Procedure for Automatic Updation */

CREATE OR ALTER PROCEDURE Bronze.load_bronze AS
BEGIN
    DECLARE @Start_Time DATETIME, @End_Time DATETIME; 
	BEGIN TRY
			PRINT '===================================================';
			PRINT 'Loading Bronze Layer';
			PRINT '===================================================';

			PRINT '---------------------------------------------------';
			PRINT 'Loading CRM Tables';
			PRINT '---------------------------------------------------';
		   /* Delete all the rows in Table Bronze.crm_cust_info through Truncate;
			 Then load the  data from CSV file in your System;
			With Bulk Insert Function where First Row of CSV File is Skipped because it is Column Header
			AND Seprator would be Comma (,) */

			SET @Start_Time = GETDATE ();

			PRINT '>>Truncating Table : Bronze.crm_cust_info';
			TRUNCATE TABLE Bronze.crm_cust_info;

			PRINT '>>> Inserting Data Into : Bronze.crm_cust_info';
			BULK INSERT Bronze.crm_cust_info
			FROM 'D:\Local Disk D\Courses\SQL\SQL Data Warehouse\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
			WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);

			/*  Count the Rows which are affected after executing the Query and 
			it should be come as 18,493 rows 
			Select
			Count(*) AS [Total Rows]
			From Bronze.crm_cust_info */

		    SET @End_Time = GETDATE ();
			PRINT 'Load Duration : ' + CAST (DATEDIFF (second,@Start_Time, @End_Time) AS NVARCHAR) + 'Seconds';

			/* Delete all the rows in Table Bronze.crm_prd_info through Truncate;
			 Then load the  data from CSV file in your System;
			With Bulk Insert Function where First Row of CSV File is Skipped because it is Column Header
			AND Seprator would be Comma (,) */
			PRINT '*********************************************************************************************'

			SET @Start_Time = GETDATE ();

			PRINT '>>Truncating Table : Bronze.crm_prd_info';
			TRUNCATE TABLE Bronze.crm_prd_info;

			PRINT '>>> Inserting Data into : Bronze.crm_prd_info';
			BULK INSERT Bronze.crm_prd_info
			FROM 'D:\Local Disk D\Courses\SQL\SQL Data Warehouse\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
			WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);

		    SET @End_Time = GETDATE ();
			PRINT 'Load Duration : ' + CAST (DATEDIFF (second,@Start_Time, @End_Time) AS NVARCHAR) + 'Seconds';

			PRINT '*********************************************************************************************'


			/* Delete all the rows in Table Bronze.crm_sales_details through Truncate;
			 Then load the  data from CSV file in your System;
			With Bulk Insert Function where First Row of CSV File is Skipped because it is Column Header
			AND Seprator would be Comma (,) */

			SET @Start_Time = GETDATE ();

			PRINT '>>Truncating Table : Bronze.crm_sales_details';
			TRUNCATE TABLE Bronze.crm_sales_details;

			PRINT '>>> Inserting Data into : Bronze.crm_sales_details';
			BULK INSERT Bronze.crm_sales_details
			FROM 'D:\Local Disk D\Courses\SQL\SQL Data Warehouse\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
			WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);

			SET @End_Time = GETDATE ();
			PRINT 'Load Duration : ' + CAST (DATEDIFF (second,@Start_Time, @End_Time) AS NVARCHAR) + 'Seconds';

			PRINT '*********************************************************************************************'



			PRINT '---------------------------------------------------';
			PRINT 'Loading ERP Tables';
			PRINT '---------------------------------------------------';

			/* Delete all the rows in Table Bronze.erp_loc_a101 through Truncate;
			 Then load the  data from CSV file in your System;
			With Bulk Insert Function where First Row of CSV File is Skipped because it is Column Header
			AND Seprator would be Comma (,) */


		    SET @Start_Time = GETDATE ();

			PRINT '>>Truncating Table : Bronze.erp_loc_a101';
			TRUNCATE TABLE Bronze.erp_loc_a101;

			PRINT '>>> Inserting Data into : Bronze.erp_loc_a101';
			BULK INSERT Bronze.erp_loc_a101
			FROM 'D:\Local Disk D\Courses\SQL\SQL Data Warehouse\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
			WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);

			SET @End_Time = GETDATE ();
			PRINT 'Load Duration : ' + CAST (DATEDIFF (second,@Start_Time, @End_Time) AS NVARCHAR) + 'Seconds';

			PRINT '*********************************************************************************************'


			/* Delete all the rows in Table Bronze.erp_cust_az12 through Truncate;
			 Then load the  data from CSV file in your System;
			With Bulk Insert Function where First Row of CSV File is Skipped because it is Column Header
			AND Seprator would be Comma (,) */


			SET @Start_Time = GETDATE ();

			PRINT '>>Truncating Table : Bronze.erp_cust_az12';
			TRUNCATE TABLE Bronze.erp_cust_az12;

			PRINT '>>> Inserting Data into : Bronze.erp_cust_az12';
			BULK INSERT Bronze.erp_cust_az12
			FROM 'D:\Local Disk D\Courses\SQL\SQL Data Warehouse\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
			WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);


			SET @End_Time = GETDATE ();
			PRINT 'Load Duration : ' + CAST (DATEDIFF (second,@Start_Time, @End_Time) AS NVARCHAR) + 'Seconds';

			PRINT '*********************************************************************************************'

			/* Delete all the rows in Table Bronze.erp_px_cat_g1v2 through Truncate;
			 Then load the  data from CSV file in your System;
			With Bulk Insert Function where First Row of CSV File is Skipped because it is Column Header
			AND Seprator would be Comma (,) */

			SET @Start_Time = GETDATE ();

			PRINT '>>Truncating Table : Bronze.erp_px_cat_g1v2';
			TRUNCATE TABLE Bronze.erp_px_cat_g1v2;

			PRINT '>>> Inserting Data into : Bronze.erp_px_cat_g1v2';
			BULK INSERT Bronze.erp_px_cat_g1v2
			FROM 'D:\Local Disk D\Courses\SQL\SQL Data Warehouse\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
			WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);

			SET @End_Time = GETDATE ();
			PRINT 'Load Duration : ' + CAST (DATEDIFF (second,@Start_Time, @End_Time) AS NVARCHAR) + 'Seconds';

			PRINT '*********************************************************************************************'

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

