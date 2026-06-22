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

SELECT count_employees('Sales Manager', 'Sales', 'United Kingdom');

