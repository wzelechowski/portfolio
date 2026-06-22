CREATE SEQUENCE visitor_id_seq
    START WITH 100
    INCREMENT BY 10;

CREATE TABLE visitors (
    visitor_id INT DEFAULT NEXT VALUE FOR visitor_id_seq PRIMARY KEY,
    employee_id NUMERIC(6, 0) NOT NULL,
    company VARCHAR(255),
    people_number INT,
    parking BIT,
    enter_datetime DATETIME DEFAULT GETDATE(),
    exit_datetime DATETIME,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CHECK (exit_datetime > enter_datetime AND exit_datetime <= GETDATE())
);

---------------------------------------------------------------------------

INSERT INTO visitors (employee_id, company, people_number, parking, enter_datetime, exit_datetime)
SELECT e.employee_id, 'RSM', 1, 1, '2024-10-13 09:00:00', '2024-10-13 10:00:00'
FROM employees e
WHERE e.first_name = 'Daniel' AND e.last_name = 'Faviet';

INSERT INTO visitors (employee_id, company, people_number, parking, enter_datetime, exit_datetime)
SELECT e.employee_id, 'KPMG', 3, 0, '2024-10-14 10:00:00', '2024-10-14 11:30:00'
FROM employees e
WHERE e.first_name = 'Daniel' AND e.last_name = 'Faviet';

------------------------------------------------------------------------------

ALTER TABLE visitors
DROP COLUMN parking;

------------------------------------------------------------------------------

UPDATE visitors
SET employee_id = (SELECT employee_id FROM employees WHERE first_name = 'John' AND last_name = 'Chen')
WHERE company = 'KPMG';

------------------------------------------------------------------------------

DELETE FROM visitors
WHERE employee_id = (SELECT employee_id FROM employees WHERE first_name = 'Daniel' AND last_name = 'Faviet');

-------------------------------------------------------------------------------

DROP TABLE visitors;
