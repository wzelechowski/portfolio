--1. skrypt 1
begin transaction;
select * from employees where MONTH(hire_date) = 12;
WAITFOR DELAY '00:00:15';
select * from employees where MONTH(hire_date) = 12;
commit transaction;
go

--2. skrypt 2
begin transaction;
INSERT INTO employees VALUES ( 222 , 'Steven' , 'King' , 'fasdasdas' , '111.111.111' , CONVERT(DATE, '01-12-2022', 105) , 'AD_PRES' , 24000 , NULL , NULL , 90 );
commit transaction;
go


--4. Wyœwietl wszystkich pracowników, którzy zostali zatrudnieni w grudniu.
select * from employees where MONTH(hire_date) = 12;

--5. Jakie zjawisko zaprezentowano w tym zadaniu?
-- Odczyt widmo (Phantom reads)

--6. Na jakim minimalnym poziomie izolacji nie mog³oby dojœæ do jego wyst¹pienia?
-- Serializable
----------------------------------------------------------------