--1. skrypt 1 
begin;
do $$
begin
	update jobs set min_salary = 5000 where job_title = 'Programmer';
	perform pg_sleep(15);
	update employees set salary = 5000 where employee_id = 103;
end;
$$ LANGUAGE plpgsql;
commit;

--2. skrypt 2
begin;
do $$
begin
	update employees set salary = 5000 where employee_id = 103;
	perform pg_sleep(15);
	update jobs set min_salary = 5000 where job_title = 'Programmer';
end;
$$ LANGUAGE plpgsql;
commit;

--4. Poczekaj, aż zostanie wyświetlony odpowiedni komunikat.
--w sesji 2:
--ERROR:  Proces 21660 oczekuje na ShareLock na transakcja 1417; zablokowany przez 18256.
--Proces 18256 oczekuje na ShareLock na transakcja 1418; zablokowany przez 21660.wykryto zakleszczenie 

--BŁĄD:  wykryto zakleszczenie
--SQL state: 40P01
--Detail: Proces 21660 oczekuje na ShareLock na transakcja 1417; zablokowany przez 18256.
--Proces 18256 oczekuje na ShareLock na transakcja 1418; zablokowany przez 21660.
--Hint: Przejrzyj dziennik serwera by znaleźć szczegóły zapytania.
--Context: podczas modyfikacji krotki (0,38) w relacji "jobs"
--wyrażenie SQL "update jobs set min_salary = 5000 where job_title = 'Programmer'"
--funkcja PL/pgSQL inline_code_block, wiersz 5 w wyrażenie SQL


--5. Jakie zjawisko zaprezentowano w tym zadaniu?
-- Zakleszczenie (oczekiwanie na dane zablokowane przez inną sesję)