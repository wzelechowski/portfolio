--zaznaczyc IMPLICIT_TRANSACTIONS w ustawieniach 

--1. W ramach sesji nr 1 rozpocznij transakcjê.
begin transaction;
--2. W ramach sesji nr 1 wyœwietl listê blokad, za które odpowiedzialna jest ta sesja.
select *
from sys.dm_tran_locks
where request_session_id = @@spid
--3. W ramach sesji nr 1 na ca³y czas trwania transakcji za³ó¿ blokadê dzielon¹ na tabeli pracowników.
select* from employees WITH (HOLDLOCK, tablock) where employee_id = null;
--4. W ramach sesji nr 1 wyœwietl listê blokad, za które odpowiedzialna jest ta sesja.
select *
from sys.dm_tran_locks
where request_session_id = @@spid

--5. W ramach sesji nr 2 rozpocznij transakcjê.
begin transaction;
--6. W ramach sesji nr 2 wyœwietl wszystkich pracowników.
select * from employees;
--7. W ramach sesji nr 2 podwy¿sz o 100 z³ pensjê wszystkich pracowników.
update employees set salary = salary + 100;

--8. W ramach sesji nr 1 zatwierdŸ transakcjê.
commit transaction;
--9. W ramach sesji nr 1 wyœwietl listê blokad, za które odpowiedzialna jest ta sesja.
select *
from sys.dm_tran_locks
where request_session_id = @@spid

--10. W ramach sesji nr 2 wycofaj transakcjê.
rollback transaction;

--11. W którym momencie uda³o Ci siê podwy¿szyæ pensjê wszystkich pracowników w ramach sesji nr 2?
--Po zatwierdzeniu transakcji w kroku 8.