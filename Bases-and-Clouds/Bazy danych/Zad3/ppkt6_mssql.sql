--1. skrypt 1 
begin transaction;
update jobs set max_salary = 30000 where job_title = 'President';
waitfor delay '00:00:15';
update employees set salary = 30000 where employee_id = 100;
commit transaction;
go

--2. skrypt 2
begin transaction;
update employees set salary = 30000 where employee_id = 100;
waitfor delay '00:00:15';
update jobs set max_salary = 30000 where job_title = 'President';
commit transaction;
go

--4. Poczekaj, a¿ zostanie wyœwietlony odpowiedni komunikat.
--w sesji 2:
--Msg 1205, Level 13, State 51, Line 5
--Transaction (Process ID 71) was deadlocked on lock resources with another process and has been chosen as the deadlock victim. Rerun the transaction.


--5. Jakie zjawisko zaprezentowano w tym zadaniu?
-- Zakleszczenie (oczekiwanie na dane zablokowane przez inn¹ sesjê)