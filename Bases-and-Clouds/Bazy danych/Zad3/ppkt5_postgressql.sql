--AUTOCOMMIT OFF
--1. W ramach sesji nr 1 rozpocznij transakcję.
begin;

--2. W ramach sesji nr 1 wyświetl listę wszystkich blokad.
select * from pg_locks;

--3. W ramach sesji nr 1 na cały czas trwania transakcji załóż blokadę wyłączną na tabeli stanowisk.
LOCK TABLE jobs IN ACCESS EXCLUSIVE MODE;

--4. W ramach sesji nr 1 wyświetl listę wszystkich blokad.
select * from pg_locks;

--5. W ramach sesji nr 1 podwyższ o 100 zł maksymalną pensję na wszystkich stanowiskach.
update jobs set max_salary = max_salary + 100;

--6. W ramach sesji nr 2 rozpocznij transakcję.
begin;

--7. W ramach sesji nr 2 wyświetl wszystkie stanowiska.
select * from jobs;

--8. W ramach sesji nr 1 wycofaj transakcję.
rollback;

--9. W ramach sesji nr 2 zatwierdź transakcję.
commit;

--10. W ramach sesji nr 1 wyświetl listę wszystkich blokad.
select * from pg_locks;

--11. W którym momencie udało Ci się wyświetlić wszystkie stanowiska w ramach sesji nr 2?
-- Po wycofaniu transakcji w kroku 9. (po zwolnieniu blokady wyłącznej)