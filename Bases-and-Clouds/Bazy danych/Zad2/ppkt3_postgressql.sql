CREATE OR REPLACE FUNCTION count_employees(
    job_title_fun VARCHAR(35),
    department_name_fun VARCHAR(30),
    country_name_fun VARCHAR(40)
) RETURNS INTEGER AS $$
BEGIN
    RETURN (
        SELECT COUNT(e.employee_id)
        FROM employees e
        JOIN jobs j ON e.job_id = j.job_id
        JOIN departments d ON e.department_id = d.department_id
        JOIN locations l ON d.location_id = l.location_id
        JOIN countries c ON l.country_id = c.country_id
        WHERE j.job_title = job_title_fun
          AND d.department_name = department_name_fun
          AND c.country_name = country_name_fun
    );
END;
$$ LANGUAGE plpgsql;


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

CREATE OR REPLACE PROCEDURE change_job_title_procedure(
    IN current_job_title VARCHAR(100),
    IN new_job_title VARCHAR(100),
    IN country_name_param VARCHAR(100),
    OUT employee_count INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    department_name_var VARCHAR(100);
	employee_id NUMERIC(6, 0);
    first_name VARCHAR(100);
    last_name VARCHAR(100);
	department_id_var VARCHAR(100);
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM countries c WHERE c.country_name = country_name_param
    ) THEN
        RAISE EXCEPTION 'Brak kraju %!', country_name_param;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM departments d
        JOIN locations l ON d.location_id = l.location_id
        JOIN countries c ON l.country_id = c.country_id
        WHERE c.country_name = country_name_param
    ) THEN
        RAISE EXCEPTION 'Brak departamentów w kraju %!', country_name_param;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM employees e
        JOIN departments d ON e.department_id = d.department_id
        JOIN locations l ON d.location_id = l.location_id
        JOIN countries c ON l.country_id = c.country_id
        WHERE c.country_name = country_name_param
    ) THEN
        RAISE EXCEPTION 'Brak pracowników zatrudnionych w kraju %!', country_name_param;
    END IF;

    IF EXISTS (SELECT FROM pg_tables WHERE tablename = 'temp_updated_employees') THEN
        DROP TABLE temp_updated_employees;
    END IF;

    CREATE TEMP TABLE temp_updated_employees AS
    SELECT 
        e.employee_id, 
        e.first_name, 
        e.last_name, 
        d.department_name,
        new_job_title AS simulated_job_title
    FROM employees e
    JOIN jobs j ON e.job_id = j.job_id
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    WHERE j.job_title = current_job_title AND c.country_name = country_name_param;

	SELECT SUM(count_employees(current_job_title, d.department_name, country_name_param))
    INTO employee_count
    FROM departments d
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    WHERE c.country_name = country_name_param;
	
    UPDATE employees e
    SET job_id = (
        SELECT j_new.job_id 
        FROM jobs j_new
        WHERE j_new.job_title = new_job_title
    )
    WHERE e.employee_id IN (
        SELECT te.employee_id
        FROM temp_updated_employees te
    );

    FOR department_name_var IN
        SELECT d.department_name
        FROM departments d
        JOIN locations l ON d.location_id = l.location_id
        JOIN countries c ON l.country_id = c.country_id
        WHERE c.country_name = country_name_param
    LOOP
        IF EXISTS (
            SELECT 1
            FROM temp_updated_employees te
            WHERE te.department_name = department_name_var
        ) THEN
            RAISE NOTICE 'Departament: %', department_name_var;

            FOR employee_id, first_name, last_name IN
                SELECT te.employee_id, te.first_name, te.last_name
                FROM temp_updated_employees te
                WHERE te.department_name = department_name_var
            LOOP
                RAISE NOTICE '  Employee ID: %, Name: % %', employee_id, first_name, last_name;
            END LOOP;
        ELSE
            RAISE WARNING 'Brak pracowników na stanowisku % w departamencie % w kraju %!',
                current_job_title, department_name_var, country_name_param;
        END IF;
    END LOOP;

END;
$$;



DO $$
DECLARE
    result_count INTEGER;
BEGIN

		
    CALL change_job_title_procedure(
        'Sales Manager',
        'Sales Representative',
        'United Kingdom',
        result_count
    );
    RAISE NOTICE 'Liczba pracowników: %', result_count;

END;
$$;