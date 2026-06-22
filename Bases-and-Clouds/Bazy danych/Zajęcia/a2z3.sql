---247659---247806---247833---247775---

---Dla MSQL Server oraz PostgreSQL---

SELECT 
    CONCAT(first_name, ' ', last_name) AS Name,
    REPLACE(job_title, 'Clerk', 'Assistant') AS Job,
    CONCAT('$', salary) AS Salary,
    REPLACE(phone_number, '.', '-') AS Phone_number
FROM employees e
JOIN jobs j ON e.job_id = j.job_id;
