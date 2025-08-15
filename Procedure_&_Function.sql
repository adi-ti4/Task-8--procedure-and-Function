Use abc_company;

-- Procedure to get employees above a certain salary
DELIMITER $$

CREATE PROCEDURE HighSalary(IN min_salary Decimal(10,2))
BEGIN
  Select Emp_id, Name, Salary
  From emp_details
  Where Salary > min_salary
  Order By Salary DESC;
END$$

DELIMITER ;

CALL HighSalary (80000.00);

-- Function to calculate annual salary from monthly salary

DELIMITER $$
Create Function AnnualSalary(monthly_salary DECIMAL(10,2))
Returns Decimal(12,2)
Deterministic
BEGIN
  Return monthly_salary * 12;
END$$

DELIMITER ;

SELECT AnnualSalary(55000) AS Annual_Income;
SELECT Emp_id, Name, Salary As monthly_salary, AnnualSalary(Salary) AS yearly_salary
From emp_details;

Delimiter $$

-- Parameters and Conditional logic

CREATE PROCEDURE GetEmployeesByDeptOrSalary(
    IN dept_name VARCHAR(50),
    IN min_salary DECIMAL(10,2)
)
BEGIN
    IF dept_name IS NOT NULL AND min_salary IS NULL THEN
        SELECT e.Emp_id, e.Name, e.Salary
        FROM emp_details e
        JOIN Departments d ON e.Dep_id = d.Dep_id
        WHERE d.Department = dept_name;

    ELSEIF dept_name IS NULL AND min_salary IS NOT NULL THEN
        SELECT Emp_id, Name, Salary
        FROM emp_details
        WHERE Salary > min_salary;

    ELSE
        SELECT e.Emp_id, e.Name, e.Salary, d.Department
        FROM emp_details e
        JOIN Departments d ON e.Dep_id = d.Dep_id
        WHERE d.Department = dept_name
        AND Salary > min_salary;
    END IF;
END$$
Delimiter ;


CALL GetEmployeesByDeptOrSalary('IT', NULL);       -- All IT employees  

CALL GetEmployeesByDeptOrSalary(NULL, 80000);      -- All employees > 80k  

CALL GetEmployeesByDeptOrSalary('Finance', 75000); -- Finance employees > 75k
