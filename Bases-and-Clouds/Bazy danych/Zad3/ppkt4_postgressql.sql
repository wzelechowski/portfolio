--AUTOCOMMIT OFF
--1. W ramach sesji nr 1 rozpocznij transakcję.
begin;

--2. W ramach sesji nr 1 wyświetl listę wszystkich blokad.
SELECT * FROM pg_locks;

--3. W ramach sesji nr 1 na cały czas trwania transakcji załóż blokadę dzieloną na tabeli stanowisk.
LOCK TABLE jobs IN SHARE MODE;

--4. W ramach sesji nr 1 wyświetl listę wszystkich blokad.
SELECT * FROM pg_locks;

--5. W ramach sesji nr 2 rozpocznij transakcję.
begin;

--6. W ramach sesji nr 2 wyświetl wszystkie stanowiska.
select * from jobs;

--7. W ramach sesji nr 2 podwyższ o 100 zł maksymalną pensję na wszystkich stanowiskach.
update jobs set max_salary = max_salary + 100;

--8. W ramach sesji nr 1 zatwierdź transakcję.
commit;

--9. W ramach sesji nr 2 wycofaj transakcję.
rollback;

--10. W ramach sesji nr 1 wyświetl listę wszystkich blokad.
SELECT * FROM pg_locks;

--11. W którym momencie udało Ci się podwyższyć maksymalną pensję na wszystkich stanowiskach w ramach sesji nr 2?
--Przy wykonywaniu update w kroku 7.