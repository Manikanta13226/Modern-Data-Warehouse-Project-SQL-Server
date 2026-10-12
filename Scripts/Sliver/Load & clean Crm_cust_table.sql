-- before load and clean the sliver layer if have to check the quality of the data then only will perform the transformations on a dataset 

--- check for null or duplicates in primary key
-- expecations : No Result 

select cst_id,
count(*)
from bronze.crm_cust_info
group by cst_id
having count(*)>1 or cst_id is null;

-- here i am focusing on the issues 
select *
from(
select *,
row_number () over (partition by cst_id order by cst_create_date desc) as flag_last
from bronze.crm_cust_info
) t where flag_last = 1 

-- now i am going to check for unwanted spaces 
-- my expectation in future: No result 
select cst_firstname
from bronze.crm_cust_info
where cst_firstname != trim(cst_firstname)

-- check for every string column 
select cst_lastname
from bronze.crm_cust_info
where cst_lastname != trim(cst_lastname)

select cst_gndr
from bronze.crm_cust_info
where cst_gndr != trim(cst_gndr)

-- data standarization and consistency 
select distinct cst_gndr
from bronze.crm_cust_info

select distinct cst_matrial_status
from bronze.crm_cust_info
-- here we aim to store clear and meaningful values rather than using abbreviated terms 

-- okay we will perform the transformations 
--- this is main part 
insert into silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_matrial_status,
	cst_gndr,
	cst_create_date)
select cst_id,
cst_key,
trim(cst_firstname) as cst_firstname,
trim(cst_lastname) as cst_lastname,
case when upper(trim(cst_gndr)) ='S' then 'Single'
	 when upper(trim(cst_gndr)) ='M' then 'Married'
	 else 'n/a'
end cst_matrial_status,
case when upper(trim(cst_gndr)) ='F' then 'Female'
	 when upper(trim(cst_gndr)) ='M' then 'Male'
	 else 'n/a'
end cst_gndr,
cst_create_date
from(
select *,
row_number () over (partition by cst_id order by cst_create_date desc) as flag_last
from bronze.crm_cust_info
where cst_id is not null
) t where flag_last = 1 


-- in above i performed the tranformation on the dataset now time for quality check of the silver table 
--- check for null or duplicates in primary key
-- expecations : No Result 

select cst_id,
count(*)
from silver.crm_cust_info
group by cst_id
having count(*)>1 or cst_id is null;

 
-- my expectation : No result 
select cst_firstname
from silver.crm_cust_info
where cst_firstname != trim(cst_firstname)

select cst_lastname
from silver.crm_cust_info
where cst_lastname != trim(cst_lastname)

select cst_gndr
from silver.crm_cust_info
where cst_gndr != trim(cst_gndr)

select cst_matrial_status
from silver.crm_cust_info
where cst_matrial_status != trim(cst_matrial_status)

select * from silver.crm_cust_info