

create or alter procedure bronze.load_bronze as 
begin 
	print '==================================================================';
	print 'Loading Bronze Layer';
	print'===================================================================';


	print'---------------------------------------------------------------';
	print'Loading CRM Tables';
	print'---------------------------------------------------------------';
	
	truncate table bronze.crm_cust_info;
	BULK INSERT bronze.crm_cust_info
	FROM  'C:\projects 2026 tasks\sql-data-warehouse-project-main\Data Warehouse project\Datasets\source_crm\cust_info.csv'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	select count(*) from bronze.crm_cust_info;


	truncate table bronze.crm_prd_info;
	BULK INSERT bronze.crm_prd_info
	FROM 'C:\projects 2026 tasks\sql-data-warehouse-project-main\Data Warehouse project\Datasets\source_crm\prd_info.csv'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR =',',
		TABLOCK
	);

	select count(*) from bronze.crm_prd_info;


	truncate table bronze.crm_sales_details;
	BULK INSERT bronze.crm_sales_details
	FROM 'C:\projects 2026 tasks\sql-data-warehouse-project-main\Data Warehouse project\Datasets\source_crm\sales_details.csv'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR =',',
		TABLOCK
	);

	select count(*) from bronze.crm_sales_details;
	print'-----------------------------------------------------------------------------';
	print'Loading ERP Tables';
	print'-----------------------------------------------------------------------------';

	truncate table bronze.erp_cust_az12;
	BULK INSERT bronze.erp_cust_az12
	FROM 'C:\projects 2026 tasks\sql-data-warehouse-project-main\Data Warehouse project\Datasets\source_erp\CUST_AZ12.csv'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR =',',
		TABLOCK
	);

	select count(*) from bronze.erp_cust_az12;


	truncate table bronze.erp_loc_a101;
	BULK INSERT bronze.erp_loc_a101
	FROM 'C:\projects 2026 tasks\sql-data-warehouse-project-main\Data Warehouse project\Datasets\source_erp\LOC_A101.csv'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR =',',
		TABLOCK
	);

	select count(*) from bronze.erp_loc_a101;

	truncate table bronze.erp_px_cat_g1v2;
	BULK INSERT bronze.erp_px_cat_g1v2
	FROM 'C:\projects 2026 tasks\sql-data-warehouse-project-main\Data Warehouse project\Datasets\source_erp\PX_CAT_G1V2.csv'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR =',',
		TABLOCK
	);

	select count(*) from bronze.erp_px_cat_g1v2;
end 