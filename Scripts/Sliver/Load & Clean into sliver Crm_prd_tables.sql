-- check for nulls or duplicates in primary key
-- expectation : no result 
select 
prd_id,
count(*)
from bronze.crm_prd_info
group by prd_id
having count(*) >1 or prd_id is null

-- check for nulls or negative numbers 
--expectations: No result 
select prd_cost
from bronze.crm_prd_info
where prd_cost < 0 or prd_cost is null

-- data standardization and consisitency
select distinct prd_line 
from bronze.crm_prd_info;

-- check for invaild data orders 
select* from 
bronze.crm_prd_info
where prd_end_dt< prd_start_dt;

-- DDL of silver.crm_prd_info
if object_id('silver.crm_prd_info','U') is not null
	drop table silver.crm_prd_info;
create table silver.crm_prd_info(
	prd_id int,
	cat_id nvarchar(50),
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_date datetime2 default getdate()
);


-------------------------------------------------------- loading clean data into sliver.crm_prd_info -----------------------------------------------
insert into silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
select 
	prd_id,
	replace(substring(prd_key,1,5),'-','_') as cat_id,  -- extract category id
	substring(prd_key, 7, len(prd_key)) as prd_key,  -- extract product key
	prd_nm,
	isnull(prd_cost, 0) as prd_cost,
	case upper(trim(prd_line))
	when 'M' then 'Mountain'
	when 'R' then 'Road'
	when 'S' then 'Other Sales'
	when 'T' then 'Touring'
	else 'n/a'
	end as prd_line,
	cast(prd_start_dt as date)as prd_start_dt,
	cast(lead(prd_start_dt) over (partition by prd_key order by prd_start_dt) -1 as date) as prd_end_dt
from bronze.crm_prd_info;


---- quality check-------
-- check for nulls or duplicates in primary key
-- expectation : no result 
select 
prd_id,
count(*)
from silver.crm_prd_info
group by prd_id
having count(*) >1 or prd_id is null

-- check for nulls or negative numbers 
--expectations: No result 
select prd_cost
from silver.crm_prd_info
where prd_cost < 0 or prd_cost is null

-- check for nulls or negative numbers 
--expectations: No result 
select prd_cost
from silver.crm_prd_info
where prd_cost < 0 or prd_cost is null

-- data standardization and consisitency
select distinct prd_line 
from silver.crm_prd_info;

-- check for invaild data orders 
select* from 
silver.crm_prd_info
where prd_end_dt< prd_start_dt;


select * from silver.crm_prd_info