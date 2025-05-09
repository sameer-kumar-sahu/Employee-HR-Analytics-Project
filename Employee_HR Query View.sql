-- BASIC LEVEL
-- List all active employees along with their department and job title.
CREATE VIEW all_employee AS
SELECT EmpID,CONCAT(employee.FirstName, ' ' ,employee.LastName) AS Name, DepartmentType, Title
FROM employee
WHERE EmployeeStatus = 'Active';
SELECT * FROM all_employee;


-- Retrieve the count of employees in each business unit.
CREATE VIEW count_employee_business_unit AS
SELECT BusinessUnit, count(*) AS EmployeeCount 
FROM employee
GROUP BY BusinessUnit;
SELECT * FROM count_employee_business_unit;


-- Find the average current employee rating across all departments.
CREATE VIEW average_employee_rating_department AS
SELECT DepartmentType AS department, ROUND(AVG(Current_Employee_Rating), 1) AS Avg_Rating
FROM employee
GROUP BY DepartmentType;
SELECT * FROM average_employee_rating_department;


-- List employees who have not completed any training programs.
CREATE VIEW not_complete_training_programs AS
SELECT Employee_ID, 
       CONCAT(employee.FirstName, ' ' ,employee.LastName) AS Name, 
       Training_Type, 
       Training_Outcome
FROM training_development
JOIN employee ON employee.EmpID = training_development.Employee_ID
WHERE Training_Outcome = 'Incomplete';
SELECT * FROM not_complete_training_programs;


-- Retrieve the top 10 applicants with the highest desired salary.
CREATE VIEW top_highest_salary AS
SELECT Applicant_ID,
       CONCAT(FirstName, ' ' ,LastName) AS Name,
       Desired_Salary
FROM recruitment
ORDER BY Desired_Salary DESC
LIMIT 10;
SELECT * FROM top_highest_salary;


-- Find the number of training programs each employee has completed.
CREATE VIEW training_program_complete AS
SELECT e.EmpID, CONCAT(FirstName, ' ' ,LastName) AS Name,
	   COUNT(t.Training_Program_Name) AS TrainingCount
FROM employee e
LEFT JOIN training_development t ON e.EmpID = t.Employee_ID
GROUP BY e.EmpID, e.FirstName, e.LastName;
SELECT * FROM training_program_complete;


-- Find the average satisfaction score per division.
CREATE VIEW avg_satisfaction_per_division AS
SELECT e.ivision AS Division, 
       ROUND(AVG(s.Satisfaction_Score),1) AS AvgSatisfaction
FROM employee e
JOIN employee_survay s ON e.EmpID = s.Employee_ID
GROUP BY e.ivision;
SELECT * FROM avg_satisfaction_per_division;


-- List all applicants who have more than 5 years of experience and a desired salary less than $60,000.
CREATE VIEW exprience_less_salary AS
SELECT Applicant_ID, 
       CONCAT(FirstName, ' ' ,LastName) AS Name,
       Years_of_Experience,
       Desired_Salary
FROM recruitment
WHERE Years_of_Experience > 5
  AND Desired_Salary < 60000;
SELECT * FROM exprience_less_salary;


-- Show employee distribution by marital status and gender.
CREATE VIEW employee_distribution AS
SELECT MaritalDesc AS MaritalStatus,
	   GenderCode AS Gender,
       COUNT(*) AS Count
FROM employee
GROUP BY MaritalDesc, GenderCode;
SELECT * FROM employee_distribution;


-- Compare average satisfaction score between male and female employees.
CREATE VIEW avg_satisfaction_gender AS  
SELECT e.GenderCode AS Gender,
	   ROUND(AVG(s.Satisfaction_Score),1) AS AvgSatisfactionScore
FROM employee AS e
JOIN employee_survay AS s ON e.EmpID = s.Employee_ID
GROUP BY e.GenderCode;
SELECT * FROM avg_satisfaction_gender;


-- Intermediate Level
-- Find the average tenure (ExitDate - StartDate) of employees who left the company.
CREATE VIEW avg_tenure AS
SELECT AVG(TIMESTAMPDIFF(YEAR, StartDate, ExitDate)) AS AvgTenureYears
FROM employee
WHERE ExitDate IS NOT NULL;
SELECT * FROM avg_tenure;


-- Rank all employees within their department by performance score.
CREATE VIEW department_performance_score AS
SELECT EmpID, 
       CONCAT(FirstName,' ', LastName) AS Name,
	   DepartmentType, 
       Performance_Score,
       RANK() OVER (PARTITION BY DepartmentType ORDER BY Performance_Score DESC) AS PerformanceRank
FROM employee;
SELECT * FROM department_performance_score;


-- List employees whose performance score is 'Exceeds Expectations' and have completed more than 3 training programs.
CREATE VIEW exceeds_performance AS
SELECT e.EmpID, 
       CONCAT(FirstName, ' ' ,LastName) AS Name,
       Performance_Score,
       Training_Duration
FROM employee e
JOIN training_development t ON e.EmpID = t.Employee_ID
WHERE e.Performance_Score = 'Exceeds' AND Training_Duration >= 3;
SELECT * FROM exceeds_performance;


-- Identify the top 5 departments with the highest average engagement scores.
CREATE VIEW depaartmently_engagement_scores AS
SELECT e.DepartmentType AS Department,
	   ROUND(AVG(s.Engagement_Score), 1) AS AvgEngagement
FROM employee e
JOIN employee_survay s ON e.EmpID = s.Employee_ID
GROUP BY e.DepartmentType
ORDER BY AvgEngagement DESC
LIMIT 5;
SELECT * FROM depaartmently_engagement_scores;
 
 
-- Find the correlation between training hours and current employee rating.
CREATE VIEW correlation AS
SELECT e.EmpID, e.Current_Employee_Rating,
       COALESCE(SUM(t.Training_Duration), 0) AS TotalTrainingHours
FROM employee e
LEFT JOIN training_development t ON e.EmpID = t.Employee_ID
GROUP BY e.EmpID, e.Current_Employee_Rating;
SELECT * FROM correlation;


-- Calculate the average tenure of employees who have left the company.
CREATE VIEW avg_tenure_employee AS
SELECT ROUND(AVG(DATEDIFF(ExitDate, StartDate) / 365.0), 1) AS AvgTenureYears
FROM employee
WHERE ExitDate IS NOT NULL;
SELECT * FROM avg_tenure_employee;


-- Determine which supervisor manages the most employees.
CREATE VIEW supervisor AS
SELECT
Supervisor,
COUNT(EmpID) AS Num_Employees
FROM employee
WHERE Supervisor IS NOT NULL
GROUP BY Supervisor
ORDER BY Num_Employees DESC
LIMIT 1;
SELECT * FROM supervisor;


-- Identify the most common termination type by department.
CREATE VIEW common_termination AS
SELECT DepartmentType, TerminationType, TermCount
FROM (
  SELECT DepartmentType, TerminationType, COUNT(*) AS TermCount,
         ROW_NUMBER() OVER (PARTITION BY DepartmentType ORDER BY COUNT(*) DESC) AS rn
  FROM employee
  WHERE TerminationType IS NOT NULL
  GROUP BY DepartmentType, TerminationType
) AS sub
WHERE rn = 1;
SELECT * FROM common_termination;


-- List the top 5 states with the highest number of applicants.
CREATE VIEW top_state AS
SELECT State, COUNT(*) AS ApplicantCount
FROM recruitment
GROUP BY State
ORDER BY ApplicantCount DESC
LIMIT 5;
SELECT * FROM top_state;


-- Retrieve a list of applicants with more experience than the average.
CREATE TABLE exprience AS
SELECT Applicant_ID, 
       CONCAT(FirstName, ' ' ,LastName) AS Name, 
       Years_of_Experience
FROM recruitment
WHERE Years_of_Experience > (
  SELECT AVG(Years_of_Experience) FROM recruitment
);
SELECT * FROM exprience;


-- Advanced Level
-- Create a rolling 3-month average of engagement scores per employee.
CREATE VIEW rolling_3_mon_avg AS
SELECT 
  s.Employee_ID,
  s.Survey_date,
  ROUND(AVG(s.Engagement_Score) OVER (
    PARTITION BY s.Employee_ID 
    ORDER BY s.Survey_date 
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) ) AS Rolling_3_Month_Avg
FROM employee_survay s;
SELECT * FROM rolling_3_mon_avg;


-- Calculate the average training hours per employee per department and rank departments accordingly.
CREATE VIEW Avg_Hours_Per_Employee AS
SELECT 
  e.DepartmentType,
  ROUND(SUM(t.Training_Duration) / COUNT(DISTINCT e.EmpID), 2) AS Avg_Hours_Per_Employee
FROM training_development t
JOIN employee e ON e.EmpID = t.Employee_ID
GROUP BY e.DepartmentType
ORDER BY Avg_Hours_Per_Employee DESC;
SELECT * FROM Avg_Hours_Per_Employee;


-- Identify departments where average satisfaction is below the company average.
CREATE VIEW dep_comp_avg AS
WITH DeptAvg AS (
  SELECT 
    e.DepartmentType,
    AVG(s.Satisfaction_Score) AS DeptAvgScore
  FROM employee_survay s
  JOIN employee e ON e.EmpID = s.Employee_ID
  GROUP BY e.DepartmentType
),
CompanyAvg AS (
  SELECT AVG(Satisfaction_Score) AS CompanyAvgScore FROM employee_survay
)
SELECT d.DepartmentType, d.DeptAvgScore
FROM DeptAvg d, CompanyAvg c
WHERE d.DeptAvgScore < c.CompanyAvgScore;
SELECT * FROM dep_comp_avg;


-- Create a list the top 3 employees in each division by current rating.
CREATE VIEW current_employee_rating AS
WITH RankedEmployees AS (
  SELECT 
    EmpID,
    FirstName,
    LastName,
    ivision,
    Current_Employee_Rating,
    ROW_NUMBER() OVER (PARTITION BY ivision ORDER BY Current_Employee_Rating DESC) AS rn
  FROM employee
)
SELECT EmpID, CONCAT(FirstName,' ', LastName) AS Name, ivision, Current_Employee_Rating
FROM RankedEmployees
WHERE rn <= 3;
SELECT * FROM current_employee_rating;


-- Build a cohort analysis of employees grouped by hiring quarter.
CREATE VIEW cohort_analysis AS
SELECT 
  CONCAT(YEAR(StartDate), '-Q', QUARTER(StartDate)) AS Hiring_Cohort,
  COUNT(*) AS Employee_Count
FROM employee
GROUP BY Hiring_Cohort
ORDER BY Hiring_Cohort;
SELECT * FROM cohort_analysis;


-- Find the average time between an employee's start date and their first training program.
CREATE VIEW avg_days_training AS
WITH FirstTraining AS (
   SELECT 
     Employee_ID,
     MIN(Training_Date) AS First_Training_Date
   FROM training_development
   GROUP BY Employee_ID
)
SELECT 
   ROUND(AVG(DATEDIFF(f.First_Training_Date, e.StartDate)), 2) AS Avg_Days_To_Training
FROM FirstTraining f
JOIN employee e ON e.EmpID = f.Employee_ID;
SELECT * FROM avg_days_training;


-- Calculate the average engagement score before and after completing a training program.
CREATE VIEW avg_before_after_time AS
SELECT 
  ROUND(AVG(CASE WHEN s.Survey_date < td.First_Training_Date THEN s.Engagement_Score END), 2) AS Avg_Before_Training,
  ROUND(AVG(CASE WHEN s.Survey_date >= td.First_Training_Date THEN s.Engagement_Score END), 2) AS Avg_After_Training
FROM employee_survay s
JOIN (
  SELECT 
    Employee_ID, 
    MIN(Training_Date) AS First_Training_Date
  FROM training_development
  GROUP BY Employee_ID
) td ON s.Employee_ID = td.Employee_ID;
SELECT * FROM avg_before_after_time;


