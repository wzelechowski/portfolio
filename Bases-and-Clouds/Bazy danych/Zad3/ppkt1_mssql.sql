--1. skrypt 1
begin transaction;
declare @salary numeric(8, 2);
set @salary =  (select salary from employees where employee_id = 100);
WAITFOR DELAY '00:00:15';
set @salary = @salary - 1000;
update employees set salary = @salary where employee_id = 100;
select @salary;
commit transaction;
go

--2. skrypt 2
begin transaction;
declare @salary numeric(8, 2);
set @salary =  (select salary from employees where employee_id = 100);
set @salary = @salary - 2000;
update employees set salary = @salary where employee_id = 100;
select @salary;
commit transaction;
go

--4. Wyœwietl pensjê pracownika o identyfikatorze równym 100.
select salary from employees where employee_id = 100;

--5. Jakie zjawisko zaprezentowano w tym zadaniu?
-- Utracone modyfikacje (lost updates)

--6. Na jakim minimalnym poziomie izolacji nie mog³oby dojœæ do jego wyst¹pienia?
-- Repeatable Read
----------------------------------------------------------------
update employees set salary = 24000 where employee_id = 100;
