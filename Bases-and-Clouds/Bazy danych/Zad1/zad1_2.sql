SELECT d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL
GROUP BY D.department_name, D.department_id;

-------------------------------------------------

SELECT 
    m.first_name AS manager_first_name,
    m.last_name AS manager_last_name,
    ROUND(m.salary - COALESCE(avg_emp_salary.avg_salary, 0), 2) AS salary_difference
FROM 
    employees m
JOIN (
    SELECT 
        manager_id,
        AVG(salary) AS avg_salary
    FROM 
        employees
    WHERE 
        manager_id IS NOT NULL
    GROUP BY 
        manager_id
) avg_emp_salary ON m.employee_id = avg_emp_salary.manager_id
ORDER BY salary_difference;

-- -----------------------------------------------------------------

SELECT l.city, CONCAT(l.postal_code, '_', l.country_id, 
        UPPER(RIGHT(l.city, 3))
    ) AS code
FROM locations l
WHERE l.postal_code ~ '^[0-9]{5}$'; 

----------------- MS SQL Server --------------------------------------

-- SELECT l.city, CONCAT(l.postal_code, '_', l.country_id, UPPER(RIGHT(l.city, 3))) AS code
-- FROM locations l
-- WHERE l.postal_code LIKE '[0-9][0-9][0-9][0-9][0-9]';

-- -------------------------------------------------------------------

SELECT d.department_name
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING 
    COUNT(e.employee_id) > (
        SELECT AVG(emp_count) 
        FROM (
            SELECT COUNT(e2.employee_id) AS emp_count
            FROM departments d2
            JOIN employees e2 ON d2.department_id = e2.department_id
            GROUP BY d2.department_id
        ) AS avg_emp_count
    );

--------------------------------------------------------------------

SELECT 
    e.first_name, 
    e.last_name, 
    j.job_title, 
    'actual' AS job_status
FROM 
    employees e
JOIN 
    jobs j ON e.job_id = j.job_id

UNION ALL

SELECT 
    e.first_name, 
    e.last_name, 
    j.job_title, 
    'archive' AS job_status
FROM 
    employees e
JOIN 
    job_history jh ON e.employee_id = jh.employee_id
JOIN 
    jobs j ON jh.job_id = j.job_id

ORDER BY 
    last_name, 
    first_name, 
    job_status DESC, 
    job_title;

