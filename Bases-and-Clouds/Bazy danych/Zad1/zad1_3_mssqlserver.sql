WITH hierarchy AS (
    SELECT 0 AS employee_level,
           e.first_name,
           e.last_name,
           e.manager_id,
           e.employee_id
    FROM employees e
    WHERE e.first_name = 'Diana' AND e.last_name = 'Lorentz'
    
    UNION ALL
    
    SELECT h.employee_level + 1 AS employee_level,
           m.first_name,
           m.last_name,
           m.manager_id,
           m.employee_id
    FROM employees m
    JOIN hierarchy h
    ON h.manager_id = m.employee_id
)

SELECT employee_level, first_name, last_name
FROM hierarchy
ORDER BY employee_level;
