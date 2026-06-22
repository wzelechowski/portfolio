--1. skrypt 1 
begin;

do $$
declare
    salary numeric(6);
begin
	
    select max_salary into salary
    from jobs where job_title = 'Programmer';
	
	--select dasje blad nie wskazano gdzie mają zostać zapisane wyniki zapytania
    perform pg_sleep(15);

    salary := salary - 1000;

	update jobs set max_salary = salary where job_title = 'Programmer';
    raise notice 'salary = %', salary;

end;
$$ LANGUAGE plpgsql;

COMMIT;

--2. skrypt 2
begin;

do $$
declare
    salary numeric(6);
begin
	
    select max_salary into salary
    from jobs where job_title = 'Programmer';

    salary := salary - 2000;

	update jobs set max_salary = salary where job_title = 'Programmer';
    raise notice 'salary = %', salary;

end;
$$ LANGUAGE plpgsql;

COMMIT;

--3. 
--4. Wyświetl maksymalną pensję na stanowisku Programmer.
select max_salary from jobs where job_title = 'Programmer';

--5. Jakie zjawisko zaprezentowano w tym zadaniu?
--Utracone modyfikacje (ang. lost updates) – dwie sesje modyfikują te same wiersze w tym
--samym czasie, przy czym w efekcie zapis uwzględni zmianę z jednej sesji („zwycięzca”) –
--druga z sesji nie będzie świadoma, że jej zmiana nie została uwzględniona („przegrany”).

--6. Na jakim minimalnym poziomie izolacji nie mogłoby dojść do jego wystąpienia?
-- Repeatable Read

----------------------------------------------------------------------------------------------
ROLLBACK; 
update jobs set max_salary = 10000 where job_title = 'Programmer';

