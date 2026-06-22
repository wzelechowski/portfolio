CREATE SEQUENCE visitor_id_seq
START WITH 100  
INCREMENT BY 10; 

CREATE TABLE visitors (
    visitor_id INT DEFAULT nextval('visitor_id_seq') PRIMARY KEY,
    employee_id INT NOT NULL,
    company VARCHAR(255),
    people_number INT,
    parking BOOLEAN, 
    enter_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    exit_datetime TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CHECK (exit_datetime > enter_datetime AND exit_datetime <= CURRENT_TIMESTAMP)
);

--------------------------------------------------------------------------------------

INSERT INTO visitors (employee_id, company, people_number, parking, enter_datetime, exit_datetime)
SELECT d.employee_id, 'RSM', 1, TRUE, '2024-10-13 09:00:00', '2024-10-13 10:00:00'
FROM employees d
WHERE d.first_name = 'Daniel' AND d.last_name = 'Faviet';

INSERT INTO visitors (employee_id, company, people_number, parking, enter_datetime, exit_datetime)
SELECT d.employee_id, 'KPMG', 3, FALSE, '2024-10-14 10:00:00', '2024-10-14 11:30:00'
FROM employees d
WHERE d.first_name = 'Daniel' AND d.last_name = 'Faviet';

--------------------------------------------------------------------------------------

ALTER TABLE visitors
DROP COLUMN parking;

--------------------------------------------------------------------------------------

UPDATE visitors
SET employee_id = (SELECT employee_id FROM employees d WHERE d.first_name = 'John' and d.last_name = 'Chen')
WHERE company = 'KPMG';

--------------------------------------------------------------------------------------

DELETE FROM visitors
WHERE employee_id = (SELECT employee_id FROM employees d WHERE d.first_name = 'Daniel' and d.last_name = 'Faviet')

--------------------------------------------------------------------------------------

DROP TABLE visitors;


