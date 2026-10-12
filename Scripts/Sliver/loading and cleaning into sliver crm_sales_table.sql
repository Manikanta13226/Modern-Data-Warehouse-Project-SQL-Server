-- check invaild sales 
select 
nullif(sls_due_dt,0) sls_due_dt
from bronze.crm_sales_details
where sls_due_dt<=0
or len(sls_due_dt) != 8
or sls_due_dt > 20500101
or sls_due_dt < 19000101

-- check for invaild date orders 
select *
from bronze.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt

-- check consistency: Between sales, quantity, and price 
--->> sales = quantity * price 
--->> values must not be null , zero or negative.

select distinct 
sls_sales,
sls_quantity,
sls_price
from bronze.crm_sales_details
where sls_sales != sls_quantity * sls_price
or sls_sales is null or sls_quantity is null or sls_price is null 
or  sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
order by sls_sales, sls_quantity, sls_price

select distinct 
sls_sales as old_sales,
sls_quantity,
sls_price as old_sales,
case when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity * abs(sls_price)
				then sls_quantity * abs(sls_price) 
			else sls_sales 
end as sls_sales,
case when sls_price is null or sls_price <= 0
		then sls_sales / nullif(sls_quantity,0) 
	else sls_price 
end as sls_price 
from bronze.crm_sales_details
where sls_sales!= sls_quantity*sls_price
or  sls_sales is null or  sls_quantity is null or sls_price is null
or sls_sales < =0 or sls_quantity <=0 or  sls_price <=0 
order by sls_sales, sls_quantity, sls_price;



------- loading clean data into silver.crm_sales_details----------
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sls_ord_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    DATE,
    sls_ship_dt     DATE,
    sls_due_dt      DATE,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


INSERT INTO silver.crm_sales_details (
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
		SELECT 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE 
				WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			END AS sls_order_dt,
			CASE 
				WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			END AS sls_ship_dt,
			CASE 
				WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			END AS sls_due_dt,
			CASE 
				WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
					THEN sls_quantity * ABS(sls_price)
				ELSE sls_sales
			END AS sls_sales, -- Recalculate sales if original value is missing or incorrect
			sls_quantity,
			CASE 
				WHEN sls_price IS NULL OR sls_price <= 0 
					THEN sls_sales / NULLIF(sls_quantity, 0)
				ELSE sls_price  -- Derive price if original value is invalid
			END AS sls_price
		FROM bronze.crm_sales_details;

