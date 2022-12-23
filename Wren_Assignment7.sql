/*--------------------------------------------------------------------------

The Company databse stores data about its employees, their departments and assignments 
and projects in the following tables.

Employee                       Assignment                                 Project
empSSN                         workempSSN                                 projNumber 
empLName                       workProjNumber                             projName 
empFName                       workHours                                  projLocation 
empGender                      workHoursplanned                           projdeptNum 
empAddress 
empDOB 
empSalary 
empDeptNum 
empSuperSSN 

Department                  Dept_Location
deptnum deptName            Deptnum 
deptMgrSSN                  deptlocation 
deptMgr_startdate 

The Company is organized in separate departments. Each department has a unique 
deptnum and has a department name. Each department has a manager and the date on 
which the manager started managing the department. The manager’s social security 
number is stored in the department table and it provides a foreign key link to the specific 
employee that manages a department. 
Each department may have multiple city locations within the company. The primary key 
of the dept_location table is the composite of deptnum and the deptlocation. The deptnum 
also serves as a foreign key link back to the departments table. 
The Employee table stores employee information. Each employee is identified by 
empSSN. Each employee works in a department. Some employees also mange 
departments. A department can have 0, 1 or more assigned employees. Through the 
empDeptNum we have a foreign key relationship with the Department table. Each 
department has 1 manager and so an employee may have a manager . Some employees 
maybe manager themselves. 
The Project table contains details about each project that the company has. Projects for 
the company are controlled by departments. Each project has a project number 
(projNumber) and they are kept track of by project name (projName) and by location. A 
department may have 0, 1 or more projects, and a project belongs to 1 and only one 
department. 
The Assignment table keeps track of project assignments. Each employee is assigned to 
work on 0, 1 or more projects. It associates the employee and project tables. The primary 
key is a composite of the primary key from the employee table combined with the 
primary key from the project table. 

--------------------------------------------------------------------------*/

/*--------------------------------------------------------------------------
1. The Department table stores information about departments within the company. 
The deptMgr_startdate column stores the start date on which an employee started 
working as a department manager.Write a query to display the date for the 
manager that has worked the longest as a department manager. Label the output 
column as Longest Working Manager. 
--------------------------------------------------------------------------*/

SELECT TOP 1 deptMgr_startdate AS [Longest Working Manager]
FROM Department
ORDER BY deptMgr_startdate 
ASC;

/*--------------------------------------------------------------------------
2. Accountants working on the company’s annual budgeting process needs to know 
the average salary for employees and the sum of all employee salaries. All 
information is in the Employee table. 
--------------------------------------------------------------------------*/

SELECT AVG(empSalary) AS AverageEmpSalary, SUM(empSalary)
FROM Employee;

/*--------------------------------------------------------------------------
3. The company’s VP for Project Management needs to know the number of 
projects each department is working on based on the information stored in the 
Project table. 
--------------------------------------------------------------------------*/

SELECT projdeptNum, Count(projdeptNum) AS NumOfProj
FROM Project
GROUP BY projdeptNum;

/*--------------------------------------------------------------------------
4. The Company’s VP for Project Management wants a list of projects located in 
Oklahoma or supervised by the ‘Production’ department. 
--------------------------------------------------------------------------*/

SELECT p.projName
FROM Project p join Department d 
on p.projdeptNum = d.deptnum join dept_location dl
on d.deptnum = dl.Deptnum
Where p.projLocation = 'Oklahoma' OR dl.deptlocation = 'Production';

/*--------------------------------------------------------------------------
 5. The Assignment table stores data about the hours that employees are working on 
specific projects. A senior project manager desires a list of employees(last and 
first names) who are currently working on project numbers 10, 20 or 30.Use a 
subquery approach.
--------------------------------------------------------------------------*/

SELECT empLName, empFName
FROM Employee
WHERE empSSN = (
    SELECT workempSSN
    FROM Assignment
    WHERE workProjNumber = 10, 20, 30
    );

/*--------------------------------------------------------------------------
6. Management is concerned about work productivity. Write a query that produces a 
listing of each employee who has not worked on a sinlge project till date. The 
employees name (first and last names) and their department names are to be 
displayed. 
--------------------------------------------------------------------------*/

SELECT e.empFName, e.empLName, d.deptName
FROM Employee e FULL OUTER JOIN Assignment a
ON  e.empSSN = a.workempSSN FULL OUTER JOIN Project p
ON a.workProjNumber = p.projNumber FULL OUTER JOIN d.Department
ON p.projdeptNum = d.deptnum
WHERE a.workHours IS NULL;


/*--------------------------------------------------------------------------
7. The company’s senior project manager needs to access information about 
departments that manage projects for a specific set of projects, namely those 
located in Oklahoma or Texas. Create a view named department_projects that 
includes the department number, department name , project name and location. 
Write a Select statement that displays all rows that are accessible through the 
view. 
--------------------------------------------------------------------------*/

CREATE VIEW department_projects
AS
SELECT d.deptnum, d.deptName, p.projName, dl.deptlocation
FROM Department d JOIN Dept_Location dl
ON d.deptnum = dl.Deptnum JOIN Project p
ON dl.Deptnum = p.projdeptNum
Where deptlocation = 'Oklahoma', 'Texas';


/*--------------------------------------------------------------------------
8. Demonstrate the use of the view named department_projects(created above) for 
the senior manager by writing a Select statement to query the view to display all 
row information for projects belonging to department 3.
--------------------------------------------------------------------------*/

SELECT *
FROM department_projects
Where deptnum = 3;

/*--------------------------------------------------------------------------
9. Create a table named sales_order. The table should have an identity column 
named so_number. There are 2 other columns – the sales order value(so_value) 
and the SSN for the employee who enters the sales order information 
(so_empSSN). Using INSERT statements insert 3 rows into the sales_order table. 
Write a SELECT statement that displays all the information in the sales_order 
table.
--------------------------------------------------------------------------*/

CREATE TABLE sales_order
    (
        so_number INT PRIMARY KEY IDENTITY (1,1),
        so_value MONEY,
        so_empSSN NVARCHAR(11) REFERENCES Employee(empSSN)
    );

    INSERT INTO sales_order
    VALUES(
        so_value = 20.50,
        so_empSSN = '999-99-9999'
        );
    
    INSERT INTO sales_order
    VALUES(
        so_value = 30.99,
        so_empSSN = '999-99-9998'
    );

    INSERT INTO sales_order
    VALUES(
        so_value = 52.70,
        so_empSSN = '999-99-9999'
    )



/*--------------------------------------------------------------------------
10      A. Write a stored procedure named replace_work_hours that updates the 
workHours column in the Assignment table. The procedure accepts 3 
parameters corresponding to 3 columns in the table:workempSSN, 
workProjNumber and workHours. For a given employee SSN and 
project number, the work hours passed as a parameter to the procedure 
can replace the workHours currently stored in the table.
--------------------------------------------------------------------------*/
CREATE PROC replace_work_hours
(
    @workempSSN NVARCHAR(11)
    @workProjNumber INT
    @workHours DECIMAL (10,2)
)
AS

UPDATE TABLE Assignment
SET workHours = @workHours
WHERE workempSSN = @workempSSN AND workProjNumber = @workProjNumber;

/*--------------------------------------------------------------------------
10      B. You have been notified by the manager of Project 20 to update the 
hours worked for an employee on the project. Execute the procedure 
replace_work_hours to store a new workHours column value of 15.5 for 
employee 999-55-5555 for project 20 and then display the new values in 
a result table
--------------------------------------------------------------------------*/

exec replace_work_hours @workempSSN = '999-55-5555', @workProjNumber = 20, @workHours = 15.50

/*--------------------------------------------------------------------------
11. Write an AFTER trigger named check_work_hours that fires whenever an 
UPDATE transaction executes that updates the value stored to the workHours 
column of the Assignment table. The trigger should check the new value to be 
assigned for the hours worked to enforce a business rule that an employee cannot 
report working in excess of 250 hours on a project. If the new value to be 
inserted exceeds 250 hours, then the UPDATE transaction should roll back. 
Display an appropriate error message. 
--------------------------------------------------------------------------*/

CREATE TRIGGER check_work_hours
ON Assignment
AFTER UPDATE
AS
IF EXISTS (SELECT workHours
    FROM inserted
    WHERE workHours > 250
    )
BEGIN    
THROW 6003, 'NEW HOURS SHOULD NOT EXCEED 250', 1
ROLLBACK TRAN
END