---------MS SQL Server------------------------

CREATE or ALTER TRIGGER [dbo].[wyzw1]
ON [dbo].[employees]
INSTEAD OF INSERT
AS
BEGIN
    IF (SELECT hire_date FROM inserted) > GETDATE()
    BEGIN
        PRINT('Niedozwolona operacja!');
    END
    ELSE
    BEGIN
        INSERT INTO employees SELECT * FROM inserted
    END
END;

INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES (2, 'Jan', 'Kowalski', 'jan.kowalski@example.com', GETDATE(), 'IT_PROG');

INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES (1, 'Jan', 'Kowalski', 'jan.kowalski2@example.com', DATEADD(DAY, 1, GETDATE()), 'IT_PROG');

------PostgreSQL-----------------

CREATE VIEW view_employees AS
SELECT * FROM employees;


CREATE OR REPLACE FUNCTION check_hire_date()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.hire_date > CURRENT_DATE THEN
        RAISE NOTICE 'Niedozwolona operacja!';
    ELSE
        INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
        VALUES (NEW.employee_id, NEW.first_name, NEW.last_name, NEW.email, NEW.phone_number, NEW.hire_date, NEW.job_id, NEW.salary, NEW.commission_pct, NEW.manager_id, NEW.department_id);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_hire_date_trigger
INSTEAD OF INSERT ON view_employees
FOR EACH ROW
EXECUTE FUNCTION check_hire_date();

INSERT INTO view_employees (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES (2, 'Jan', 'Kowalski', 'jan.kowalski@example.com', CURRENT_DATE, 'IT_PROG');

INSERT INTO view_employees (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES (1, 'Jan', 'Kowalski', 'jan.kowalski2@example.com', CURRENT_DATE + INTERVAL '1 day', 'IT_PROG');