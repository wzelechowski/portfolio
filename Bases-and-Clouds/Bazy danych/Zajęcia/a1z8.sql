SELECT D.department_name
FROM employees E
JOIN departments D ON E.department_id = D.department_id
GROUP BY D.department_name, D.department_id
HAVING COUNT(E.employee_id) = (
    SELECT MAX(employee_count)
    FROM (
        SELECT COUNT(E2.employee_id) AS employee_count
        FROM employees E2
        GROUP BY E2.department_id
    ) AS counts
);

SELECT D.department_name
FROM employees E
JOIN departments D ON E.department_id = D.department_id
GROUP BY D.department_name, D.department_id
HAVING COUNT(E.employee_id) >= ALL (SELECT COUNT (e2.employee_id)
									FROM employees e2
									GROUP BY department_id);