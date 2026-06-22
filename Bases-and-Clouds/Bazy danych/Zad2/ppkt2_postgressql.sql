CREATE OR REPLACE FUNCTION trigger_employee_job_change()
RETURNS TRIGGER AS $$
DECLARE
    new_min_salary NUMERIC(6);
    new_max_salary NUMERIC(6);
    current_salary NUMERIC(6);
    salary_increase NUMERIC;
BEGIN
    SELECT min_salary, max_salary INTO new_min_salary, new_max_salary
    FROM jobs
    WHERE job_id = NEW.job_id;
	
    NEW.hire_date := CURRENT_DATE + INTERVAL '1 day';

    INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
    VALUES (OLD.employee_id, OLD.hire_date, CURRENT_DATE, OLD.job_id, OLD.department_id);

    current_salary := NEW.salary;

	--jak mniejsze to podnoisi pracownikowi
    IF current_salary < new_min_salary THEN
        salary_increase := new_min_salary - current_salary;
        NEW.salary := new_min_salary;
        RAISE NOTICE 'Pracownik % % otrzymał podwyżkę o kwotę %', NEW.first_name, NEW.last_name, salary_increase;

	--jak wieksze to zmienia dla stanowiska
    ELSIF current_salary > new_max_salary THEN
        UPDATE jobs
        SET max_salary = current_salary
        WHERE job_id = NEW.job_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER job_change_trigger
BEFORE UPDATE OF job_id ON employees
FOR EACH ROW
WHEN (OLD.job_id IS DISTINCT FROM NEW.job_id)
EXECUTE FUNCTION trigger_employee_job_change();


--dobre wynagrodzenie
INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
VALUES (1000, 'imie1', 'nazwisko1', 'test1', '515.123.1234', '2000-01-01', 'IT_PROG', 11000, NULL, NULL, 60);


--wyzsze wynagrodzenie
INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
VALUES (1001, 'imie2', 'nazwisko2', 'test2', '515.123.1234', '2000-01-01', 'IT_PROG', 25000, NULL, NULL, 60);


--za niskie wynagrodzenie
INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
VALUES (1002, 'imie3', 'nazwisko3', 'test3', '515.123.1234', '2000-01-01', 'IT_PROG', 5000, NULL, NULL, 60);


UPDATE employees SET job_id = 'SA_MAN' WHERE employee_id = 1000;
UPDATE employees SET job_id = 'SA_MAN' WHERE employee_id = 1001;
UPDATE employees SET job_id = 'SA_MAN' WHERE employee_id = 1002;

UPDATE employees SET first_name = 'Marek' WHERE employee_id = 1000;

DELETE FROM job_history WHERE employee_id IN (1000, 1001, 1002);
DELETE FROM employees
WHERE employee_id IN (1000, 1001, 1002);
UPDATE jobs SET max_salary = 20080 WHERE job_id = 'SA_MAN';
