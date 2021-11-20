#UC1--- create database, show database, use database
show databases;
use employee_payroll;
SELECT database();
#-------------------------------------------------------------
#UC2--- create table
CREATE TABLE emp_payroll(
     id int unsigned not null AUTO_INCREMENT,
     name varchar(150) not null,
     salary double not null,
     start date not null,
     PRIMARY KEY (id));
#-----------------------------------------------------------
#UC3--- insert values
insert into emp_payroll(name, salary, start) values
    ('Bill',1000000.00,'2018-02-05'),
    ('Terisa',2000000.00,'2019-06-15'),
    ('Charlie',3000000.00,'2020-11-23');
#------------------------------------------------------------------
#UC4--- Use select
SELECT * from emp_payroll;
#-------------------------------------------------------------------
#UC5--- retrieve salary data for particular emp
SELECT salary from emp_payroll
	   where name = 'Bill';

SELECT * from emp_payroll
         where start between cast('2020-01-01' as date) and date(now());
#----------------------------------------------------------------------
#UC6--- add gender column and update row 
ALTER TABLE emp_payroll add gender char(1) after name;

update emp_payroll set gender = 'M' 
       where name = 'Bill' or name = 'Charlie';
update emp_payroll set gender = 'F'
    where name = 'Terisa';
SELECT * from emp_payroll;
#----------------------------------------------------------------------
#UC7----find sum avg mim max 
SELECT gender, sum(salary) from emp_payroll
       where gender = 'M' group by gender;
       
SELECT gender, avg(salary) from emp_payroll
	   where gender = 'M' group by gender;
       
SELECT name,min(salary) from emp_payroll
       where gender = 'M' group by gender;
       
SELECT name,max(salary) from emp_payroll
       where gender = 'M' group by gender;
       
SELECT count(*) from emp_payroll;
#-------------------------------------------------------------------------
# UC8 --- Extend table, add emp phone, address, department
ALTER TABLE emp_payroll add phone_no varchar(12) after name;
ALTER TABLE emp_payroll add address varchar(150) default 'Pune' after phone_no;
ALTER TABLE emp_payroll add department varchar(30) not null after address;
SELECT * from emp_payroll;
#----------------------------------------------------------------------------
#UC9-----Extend table, add Basic pay, Deductions, Taxable pay, Income Tax, Net Pay
ALTER TABLE emp_payroll rename column salary to basic_pay;
ALTER TABLE emp_payroll 
     add Deductions double after basic_pay,
     add Taxable_pay double after Deductions,
     add Income_tax double after Taxable_pay,
     add Net_Pay double after Income_tax;
SELECT * from emp_payroll;
#-----------------------------------------------------------------------------
#UC10---- ability to make Terissa as part of Sales and Marketing Department
update emp_payroll set department='Sales' where name='Terisa';
insert into emp_payroll (name, department, gender, basic_pay, Deductions, Taxable_pay, Income_tax, Net_Pay, start) values
					  ('Terisa', 'Marketing', 'F', 350000, 1500, 2000, 3000, 280000, '2018-01-03');
SELECT * from emp_payroll;
#-----------------------------------------------------------------------------
#UC11---- Implement the ER Diagram into Payroll Service DB
desc emp_payroll;
ALTER TABLE emp_payroll 
drop column department,drop column basic_pay, drop column  Deductions,
drop column  Taxable_pay,drop column  Income_tax,drop column  Net_Pay, drop column start;
SELECT * from emp_payroll;
ALTER TABLE emp_payroll
  RENAME TO emp_payroll_details;
SELECT * from emp_payroll_details;
ALTER TABLE emp_payroll_details 
RENAME COLUMN id TO eId;

create table employee_department
(
eId int, 
depart_id int,
PRIMARY KEY(eId),
foreign key(eId) references emp_payroll_details(eId),
foreign key(depart_id) references department(depart_id)
);

create table company
(company_id int not null ,
company_name varchar(150),
PRIMARY KEY(company_id));
insert into company(company_id, company_name) values
(201,'Amazon'),(202,'Flipkart');
select * from company;

alter table emp_payroll_details add company_id int first;
update emp_payroll_details set company_id =201 where eId = 1;
update emp_payroll_details set company_id =201 where eId = 2;
update emp_payroll_details set company_id =201 where eId = 3;
select * from emp_payroll_details;
desc emp_payroll_details;
alter table emp_payroll_details add foreign key(company_id) references company(company_id);

create table employee_department
(
eId int  unsigned, 
depart_id int,
PRIMARY KEY(eId),
foreign key(eId) references emp_payroll_details(eId)
);
describe employee_department;
CREATE TABLE department 
(
depart_id int not null auto_increment,
depart_name varchar(60) not null,
PRIMARY KEY(depart_id)
);
describe department;

drop table department;
insert into department(depart_name)values
('Sales'),
('Marketing'),
('Hr');
select * from department;
alter table employee_department add foreign key(depart_id) references department(depart_id);
update employee_department set depart_id = 3 where eId = 1;
update employee_department set depart_id = 2 where eId = 2;
update employee_department set depart_id = 1 where eId = 3;

create table employee_payroll_salary
(
eId int unsigned not null,
basic_pay double,
deductions double default 0,
taxable_pay double default 0,
tax double default 0,
net_pay double default 0
 );
 insert into employee_payroll_salary (eId, basic_pay)values
 (1,300000);
 
 alter table employee_payroll_salary add foreign key (eId) references emp_payroll_details (eId);

select * from emp_payroll_details;
update emp_payroll_details set phone_no =888999999 where eId = 1;
update emp_payroll_details set phone_no =999996666 where eId = 2;
update emp_payroll_details set phone_no =777766666 where eId = 3;