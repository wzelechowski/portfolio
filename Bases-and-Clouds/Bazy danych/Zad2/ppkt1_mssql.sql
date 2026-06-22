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


SELECT dbo.func('Sales Manager', 'Sales', 'United Kingdom') AS Employees