--AUTOCOMMIT OFF
--1. W ramach sesji nr 1 rozpocznij transakcję.
begin;

--2. W ramach sesji nr 1 wyświetl wszystkie stanowiska, na których minimalna pensja wynosi 2500 zł.
select * from jobs where min_salary = 2500;

--3. W ramach sesji nr 2 rozpocznij transakcję.
begin;

--4. W ramach sesji nr 2 dodaj nowe stanowisko, na którym minimalna pensja wynosi 2500 zł.
INSERT INTO jobs VALUES ( 'AAAA' , 'ASDAS' , 2500 , 40000 );

--5. W ramach sesji nr 2 zatwierdź transakcję.
commit;

--6. W ramach sesji nr 1 wyświetl wszystkie stanowiska, na których minimalna pensja wynosi 2500 zł.
select * from jobs where min_salary = 2500;

--7. W ramach sesji nr 1 zatwierdź transakcję.
commit;

--8. W ramach sesji nr 1 wyświetl wszystkie stanowiska, na których minimalna pensja wynosi 2500 zł.
select * from jobs where min_salary = 2500;

--9. Jakie zjawisko zaprezentowano w tym zadaniu?
-- Odczyt widmo (ang. Phantom reads /phantoms) – transakcja przy kolejnym
-- odczycie zwraca zbiór danych spełniających predykat warunkowy, który
-- różni się od poprzedniego (w wyniku dodania lub usunięcia wierszy) –
-- pojawiają się lub znikają wiersze danych.

--10. Na jakim minimalnym poziomie izolacji nie mogłoby dojść do jego wystąpienia?
-- Repeatable Read