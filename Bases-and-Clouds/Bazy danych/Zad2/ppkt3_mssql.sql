
CREATE OR ALTER FUNCTION func (@input1 NVARCHAR(100), @input2 NVARCHAR(100), @input3 NVARCHAR(100))
RETURNS INT 
AS BEGIN
	DECLARE @employeeCount INT

	SELECT @employeeCount = COUNT(*) from employees e
	JOIN departments d ON d.department_id = e.department_id
	JOIN locations l ON l.location_id = d.location_id
	JOIN countries c ON c.country_id = l.country_id
	JOIN jobs j ON j.job_id = e.job_id
	WHERE j.job_title = @input1
	AND d.department_name = @input2
	AND c.country_name = @input3;
	RETURN @employeeCount;
END
GO


CREATE OR ALTER TRIGGER trig
ON employees
AFTER UPDATE
AS 
BEGIN
	INSERT INTO job_history(employee_id, start_date, end_date, job_id, department_id)
	SELECT 
		d.employee_id,
		d.hire_date,
		CAST(GETDATE() AS DATE),
		d.job_id,
		d.department_id
	FROM deleted d
	JOIN inserted i on d.employee_id = i.employee_id
	WHERE
        i.job_id <> d.job_id;

	UPDATE employees
	SET hire_date = CAST(DATEADD(DAY, 1, GETDATE()) AS DATE)
	FROM inserted i
	WHERE employees.employee_id = i.employee_id
	AND i.job_id <> (SELECT job_id FROM deleted WHERE deleted.employee_id = i.employee_id);

	DECLARE @new_min_salary NUMERIC(6), @new_max_salary NUMERIC(6), @current_salary NUMERIC(6), @salary_increase NUMERIC(6);
	DECLARE @employee_id NUMERIC(6);
	DECLARE @first_name VARCHAR(20), @last_name VARCHAR(20), @job_id VARCHAR(20);
	DECLARE salary_cursor CURSOR FOR
	SELECT i.salary, j.min_salary, j.max_salary, i.employee_id, i.first_name, i.last_name, i.job_id
	FROM inserted i
	JOIN jobs j ON i.job_id = j.job_id
	WHERE i.job_id <> (SELECT job_id FROM deleted WHERE deleted.employee_id = i.employee_id);

	OPEN salary_cursor
	FETCH NEXT FROM salary_cursor INTO @current_salary, @new_min_salary, @new_max_salary, @employee_id, @first_name, @last_name, @job_id;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @current_salary < @new_min_salary
		BEGIN 
			SET @salary_increase = @new_min_salary - @current_salary
			UPDATE employees
			SET salary = @new_min_salary
			WHERE employee_id = @employee_id
			
			PRINT 'Pracownik ' + @first_name + ' ' + @last_name + ' otrzymał oodwyżkę o ' + CAST(@current_salary AS VARCHAR(10));
		END
		ELSE IF @current_salary > @new_max_salary
		BEGIN 
			UPDATE jobs
			SET max_salary = @current_salary
			WHERE job_id = @job_id
		END
		FETCH NEXT FROM salary_cursor INTO @current_salary, @new_min_salary, @new_max_salary, @employee_id, @first_name, @last_name, @job_id;
	END;
	CLOSE salary_cursor
	DEALLOCATE salary_cursor
END
GO


CREATE OR ALTER PROCEDURE changeJobTitle
    @CurrentJobTitle NVARCHAR(100),
    @NewJobTitle NVARCHAR(100),
    @Country NVARCHAR(100),
    @UpdatedCount INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
	    DECLARE @message NVARCHAR(max);

    IF NOT EXISTS (
        SELECT 1 FROM countries WHERE country_name = @Country
    )
    BEGIN
        SET @message = CONCAT('Brak kraju ', @Country, '!');
        THROW 50001, @message, 1;
    END;
	
	
    IF NOT EXISTS (
        SELECT 1 
        FROM departments d
        JOIN locations l ON d.location_id = l.location_id
        JOIN countries c ON l.country_id = c.country_id
        WHERE c.country_name = @Country
    )
    BEGIN
        SET @message = CONCAT('Brak departamentów w kraju ', @Country, '!');
        THROW 50002, @message, 1;
    END;
	
    IF NOT EXISTS (
        SELECT 1 
        FROM employees e
        JOIN departments d ON e.department_id = d.department_id
        JOIN locations l ON d.location_id = l.location_id
        JOIN countries c ON l.country_id = c.country_id
        WHERE c.country_name = @Country
    )
    BEGIN
        SET @message = CONCAT('Brak pracowników zatrudnionych w kraju ', @Country, '!');
        THROW 50003, @message, 1;
    END;
	

    SELECT @UpdatedCount = dbo.func(@CurrentJobTitle, d.department_name, @Country)
    FROM departments d
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    WHERE c.country_name = @Country

    CREATE TABLE #UpdatedEmployees (
        employee_id NUMERIC(6, 0),
        first_name NVARCHAR(100),
        last_name NVARCHAR(100),
        department_name NVARCHAR(100)
    );

    INSERT INTO #UpdatedEmployees (employee_id, first_name, last_name, department_name)
    SELECT e.employee_id, e.first_name, e.last_name, d.department_name
    FROM employees e
    JOIN jobs j ON e.job_id = j.job_id
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    WHERE j.job_title = @CurrentJobTitle AND c.country_name = @Country;

	UPDATE employees
    SET job_id = (SELECT job_id FROM jobs WHERE job_title = @NewJobTitle)
    WHERE employee_id IN (SELECT employee_id FROM #UpdatedEmployees);


	SELECT employee_id, first_name, last_name, department_name
    FROM #UpdatedEmployees;

	DECLARE @msg NVARCHAR(MAX) = '';
	
    PRINT 'Informacje o departamentach i pracownikach:';

    DECLARE @DepartmentName NVARCHAR(100);
    DECLARE departmentCursor CURSOR FOR

    SELECT d.department_name
    FROM departments d
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    WHERE c.country_name = @Country;

    OPEN departmentCursor;
    FETCH NEXT FROM departmentCursor INTO @DepartmentName;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF EXISTS (
            SELECT 1 
            FROM #UpdatedEmployees ue
            JOIN employees e ON ue.employee_id = e.employee_id
            JOIN departments d ON e.department_id = d.department_id
            WHERE d.department_name = @DepartmentName
        )
        BEGIN
            PRINT 'Departament: ' + @DepartmentName;
            SELECT @msg = STRING_AGG('Employee ID: ' + CAST(ue.employee_id AS NVARCHAR(10)) + ', Name: ' + ue.first_name + ' ' + ue.last_name, CHAR(13) + CHAR(10))
            FROM #UpdatedEmployees ue
            JOIN employees e ON ue.employee_id = e.employee_id
            JOIN departments d ON e.department_id = d.department_id
            WHERE d.department_name = @DepartmentName;
			PRINT @msg;
        END
        ELSE
        BEGIN
            PRINT 'Brak pracowników na stanowisku ' + @CurrentJobTitle + ' w departamencie ' + @DepartmentName + ' w kraju ' + @Country + '!';
        END;

        FETCH NEXT FROM departmentCursor INTO @DepartmentName;
    END;

    CLOSE departmentCursor;
    DEALLOCATE departmentCursor;
	
    DROP TABLE #UpdatedEmployees;
END
GO

DECLARE @UpdatedCount INT;

EXEC changeJobTitle 
    @CurrentJobTitle = 'Sales Manager',
    @NewJobTitle = 'Sales Representative',
    @Country = 'Polska',
    @UpdatedCount = @UpdatedCount OUTPUT;

PRINT 'Liczba zmodyfikowanych rekordów: ' + CAST(@UpdatedCount AS NVARCHAR(10));

/*
--1700

UPDATE departments
SET location_id = 1700
WHERE department_id = 120;


SELECT d.department_id, d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.department_id IS NULL;


UPDATE employees
SET hire_date = CONVERT(DATE, '01-10-2004', 105)
WHERE employee_id = 145;

UPDATE employees
SET hire_date = CONVERT(DATE, '05-01-2005', 105)
WHERE employee_id = 146;

UPDATE employees
SET hire_date = CONVERT(DATE, '10-03-2005', 105)
WHERE employee_id = 147;

UPDATE employees
SET hire_date = CONVERT(DATE, '15-10-2007', 105)
WHERE employee_id = 148;

UPDATE employees
SET hire_date = CONVERT(DATE, '29-01-2008', 105)
WHERE employee_id = 149;

DELETE FROM job_history WHERE employee_id BETWEEN 145 AND 149;

UPDATE employees
SET job_id = 'SA_MAN' WHERE employee_id BETWEEN 145 AND 149;
*/
