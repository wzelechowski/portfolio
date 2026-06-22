--1. skrypt 1
begin transaction;
select salary from employees where employee_id = 100;
WAITFOR DELAY '00:00:15';
select salary from employees where employee_id = 100;
commit transaction;
go

--2. skrypt 2
begin transaction;
update employees set salary = salary + 1000 where employee_id = 100;
commit transaction;
go

--4. Wyœwietl pensjê pracownika o identyfikatorze równym 100.
select salary from employees where employee_id = 100;

--5. Jakie zjawisko zaprezentowano w tym zadaniu?
-- Niepowtarzalne odczyty (Nonrepeatable (fuzzy) reads)

--6. Na jakim minimalnym poziomie izolacji nie mog³oby dojœæ do jego wyst¹pienia?
-- Repeatable Read
----------------------------------------------------------------
update employees set salary = 24000 where employee_id = 100;
