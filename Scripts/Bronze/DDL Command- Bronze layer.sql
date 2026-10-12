drop table bronze.crm_cust_info;

create table bronze.crm_cust_info(
cst_id int,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_matrial_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date DATE
);


create table bronze.crm_prd_info(
prd_id int,
prd_key varchar(50),
prd_nm nvarchar(50),
prd_cost int,
prd_line varchar(50),
prd_start_dt Datetime,
prd_end_dt Datetime
);

create table bronze.crm_sales_details(
sls_ord_num varchar(50),
sls_prd_key  varchar(50),
sls_cust_id int,
sls_order_dt int,
sls_ship_dt int,
sls_due_dt int,
sls_sales int,
sls_quantity int,
sls_price int
);



create table bronze.erp_loc_a101(
cid nvarchar(50),
cntry nvarchar(50)
);

create table bronze.erp_cust_az12(
cid nvarchar(50),
bdate date,
gen nvarchar(50)
);

create table bronze.erp_px_cat_g1v2(
id nvarchar(50),
cat nvarchar(50),
subcat nvarchar(50),
maintaince nvarchar(50)
);

