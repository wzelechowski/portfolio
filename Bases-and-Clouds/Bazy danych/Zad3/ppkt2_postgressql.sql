--AUTOCOMMIT MUSI BYC NA OFF
--1. W ramach sesji nr 1 rozpocznij transakcję.
begin;

--2. W ramach sesji nr 1 wyświetl maksymalną pensję na stanowisku Programmer.
select max_salary from jobs where job_title = 'Programmer';

--3. W ramach sesji nr 2 rozpocznij transakcję.
select max_salary from jobs where job_title = 'Programmer';

--4. W ramach sesji nr 2 podwyższ o 1000 zł maksymalną pensję na stanowisku Programmer.
update jobs set max_salary = max_salary + 1000
where job_title = 'Programmer';

--5. W ramach sesji nr 2 zatwierdź transakcję.
commit;

--6. W ramach sesji nr 1 wyświetl maksymalną pensję na stanowisku Programmer.
select max_salary from jobs where job_title = 'Programmer';

--7. W ramach sesji nr 1 zatwierdź transakcję.
commit;

--8. W ramach sesji nr 1 wyświetl maksymalną pensję na stanowisku Programmer.
select max_salary from jobs where job_title = 'Programmer';

--9. Jakie zjawisko zaprezentowano w tym zadaniu?
-- Niepowtarzalne odczyty (ang. Nonrepeatable (fuzzy) reads / inconsistent analysis),
--czyli transakcja odczytując ponownie dane otrzymuje wyniki różniące się od poprzednio
--odczytanych (inna transakcja zmodyfikowała dane) - użytkownik
--odczytuje zatwierdzone dane, ale za każdym razem różne

--10. Na jakim minimalnym poziomie izolacji nie mogłoby dojść do jego wystąpienia?
-- Repeatable Read


---------------------------------------------------------------
SHOW default_transaction_isolation;
--read commited