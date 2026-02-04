/* Delete all the rows in Table Bronze.crm_cust_info through Truncate;
 Then load the  data from CSV file in your System;
With Bulk Insert Function where First Row of CSV File is Skipped because it is Column Header
AND Seprator would be Comma (,) */

TRUNCATE TABLE Bronze.crm_cust_info;
BULK INSERT Bronze.crm_cust_info
FROM '<DATASET_PATH>/source_crm/customer_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
/* Note:
Replace <DATASET_PATH> with your local dataset directory before execution. */

SELECT COUNT(*) AS [Total Rows]
FROM Bronze.crm_cust_info;

/* Note 
I am Only Showing How to Load the Data in one Table i.e. Bronze.crm_cust_info 
Go and Write Same SQL BULK Insert to load all your CSV Files in All your Bronze Tables  
Thank you for your attention. */


