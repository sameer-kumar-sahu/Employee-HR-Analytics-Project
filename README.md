# Employee/HR Analytics Project Using MySQL

### Dataset Link: https://www.kaggle.com/datasets/ravindrasinghrana/employeedataset

## 📊 Project Overview

This project focuses on HR analytics using structured SQL queries to uncover actionable insights from employee, recruitment and training datasets. The objective is to support human resources and leadership teams in making data-driven decisions regarding employee engagement, performance, hiring efficiency, training effectiveness, and organizational health.

The project is divided into three levels—Basic, Intermediate, and Advanced—where each level builds progressively on analytical complexity. It uses SQL views to provide reusable and queryable insights.

## 📁 Tools Used

- Excel (Data Cleaning)

- SQL (MySQL syntax)

- Relational database schema (employee, recruitment, training_development, employee_survay)

## Business Problems and Solutions

### 1. List all active employees along with their department and job title.

```sql
CREATE VIEW all_employee AS
SELECT EmpID,CONCAT(employee.FirstName, ' ' ,employee.LastName) AS Name, DepartmentType, Title
FROM employee
WHERE EmployeeStatus = 'Active';
SELECT * FROM all_employee;
```

**Objective:** List all active employees with their department and job title

### 2. Retrieve the count of employees in each business unit.

```sql
CREATE VIEW count_employee_business_unit AS
SELECT BusinessUnit, count(*) AS EmployeeCount 
FROM employee
GROUP BY BusinessUnit;
SELECT * FROM count_employee_business_unit;
```

**Objective:**  Count employees in each business unit.

### 3. Find the average current employee rating across all departments.

```sql
CREATE VIEW average_employee_rating_department AS
SELECT DepartmentType AS department, ROUND(AVG(Current_Employee_Rating), 1) AS Avg_Rating
FROM employee
GROUP BY DepartmentType;
SELECT * FROM average_employee_rating_department;
```

**Objective:** Calculate average current employee rating by department.

### 4. List employees who have not completed any training programs.

```sql
CREATE VIEW not_complete_training_programs AS
SELECT Employee_ID, 
       CONCAT(employee.FirstName, ' ' ,employee.LastName) AS Name, 
       Training_Type, 
       Training_Outcome
FROM training_development
JOIN employee ON employee.EmpID = training_development.Employee_ID
WHERE Training_Outcome = 'Incomplete';
SELECT * FROM not_complete_training_programs;
```

**Objective:** Identify employees who have not completed any training programs.

### 5. Retrieve the top 10 applicants with the highest desired salary.

```sql
CREATE VIEW top_highest_salary AS
SELECT Applicant_ID,
       CONCAT(FirstName, ' ' ,LastName) AS Name,
       Desired_Salary
FROM recruitment
ORDER BY Desired_Salary DESC
LIMIT 10;
SELECT * FROM top_highest_salary;
```

**Objective:** Retrieve top 10 applicants with the highest desired salary.

### 6. Find the number of training programs each employee has completed.

```sql
CREATE VIEW training_program_complete AS
SELECT e.EmpID, CONCAT(FirstName, ' ' ,LastName) AS Name,
	   COUNT(t.Training_Program_Name) AS TrainingCount
FROM employee e
LEFT JOIN training_development t ON e.EmpID = t.Employee_ID
GROUP BY e.EmpID, e.FirstName, e.LastName;
SELECT * FROM training_program_complete;
```

**Objective:** Count number of training programs completed by each employee.

### 7. Find the average satisfaction score per division.

```sql
CREATE VIEW avg_satisfaction_per_division AS
SELECT e.ivision AS Division, 
       ROUND(AVG(s.Satisfaction_Score),1) AS AvgSatisfaction
FROM employee e
JOIN employee_survay s ON e.EmpID = s.Employee_ID
GROUP BY e.ivision;
SELECT * FROM avg_satisfaction_per_division;
```

**Objective:** Compute average satisfaction score per division.

### 8. List all applicants who have more than 5 years of experience and a desired salary less than $60,000.

```sql
CREATE VIEW exprience_less_salary AS
SELECT Applicant_ID, 
       CONCAT(FirstName, ' ' ,LastName) AS Name,
       Years_of_Experience,
       Desired_Salary
FROM recruitment
WHERE Years_of_Experience > 5
  AND Desired_Salary < 60000;
SELECT * FROM exprience_less_salary;
```

**Objective:** List applicants with more than 5 years experience and salary under $60,000.

### 9. Show employee distribution by marital status and gender.

```sql
CREATE VIEW employee_distribution AS
SELECT MaritalDesc AS MaritalStatus,
	   GenderCode AS Gender,
       COUNT(*) AS Count
FROM employee
GROUP BY MaritalDesc, GenderCode;
SELECT * FROM employee_distribution;
```

**Objective:** Show employee distribution by marital status and gender.

### 10. Compare average satisfaction score between male and female employees.

```sql
CREATE VIEW avg_satisfaction_gender AS  
SELECT e.GenderCode AS Gender,
	   ROUND(AVG(s.Satisfaction_Score),1) AS AvgSatisfactionScore
FROM employee AS e
JOIN employee_survay AS s ON e.EmpID = s.Employee_ID
GROUP BY e.GenderCode;
SELECT * FROM avg_satisfaction_gender;
```

**Objective:** Compare average satisfaction scores between male and female employees.

### 11. Find the average tenure (ExitDate - StartDate) of employees who left the company.

```sql
CREATE VIEW avg_tenure AS
SELECT AVG(TIMESTAMPDIFF(YEAR, StartDate, ExitDate)) AS AvgTenureYears
FROM employee
WHERE ExitDate IS NOT NULL;
SELECT * FROM avg_tenure;
```

**Objective:** Calculate average tenure of employees who exited the company.

### 12. Rank all employees within their department by performance score.

```sql
CREATE VIEW department_performance_score AS
SELECT EmpID, 
       CONCAT(FirstName,' ', LastName) AS Name,
	   DepartmentType, 
       Performance_Score,
       RANK() OVER (PARTITION BY DepartmentType ORDER BY Performance_Score DESC) AS PerformanceRank
FROM employee;
SELECT * FROM department_performance_score;
```

**Objective:** Rank employees by performance score within each department.

### 13. List employees whose performance score is 'Exceeds Expectations' and have completed more than 3 training programs.

```sql
CREATE VIEW exceeds_performance AS
SELECT e.EmpID, 
       CONCAT(FirstName, ' ' ,LastName) AS Name,
       Performance_Score,
       Training_Duration
FROM employee e
JOIN training_development t ON e.EmpID = t.Employee_ID
WHERE e.Performance_Score = 'Exceeds' AND Training_Duration >= 3;
SELECT * FROM exceeds_performance;
```

**Objective:** Identify high-performing employees who completed over 3 trainings.

### 14. Identify the top 5 departments with the highest average engagement scores.

```sql
CREATE VIEW depaartmently_engagement_scores AS
SELECT e.DepartmentType AS Department,
	   ROUND(AVG(s.Engagement_Score), 1) AS AvgEngagement
FROM employee e
JOIN employee_survay s ON e.EmpID = s.Employee_ID
GROUP BY e.DepartmentType
ORDER BY AvgEngagement DESC
LIMIT 5;
SELECT * FROM depaartmently_engagement_scores;
```

**Objective:** Find top 5 departments by average engagement score.

### 15. Find the correlation between training hours and current employee rating.

```sql
CREATE VIEW correlation AS
SELECT e.EmpID, e.Current_Employee_Rating,
       COALESCE(SUM(t.Training_Duration), 0) AS TotalTrainingHours
FROM employee e
LEFT JOIN training_development t ON e.EmpID = t.Employee_ID
GROUP BY e.EmpID, e.Current_Employee_Rating;
SELECT * FROM correlation;
```

**Objective:** Analyze relationship between training hours and current employee rating.

### 16. Calculate the average tenure of employees who have left the company.

```sql
CREATE VIEW avg_tenure_employee AS
SELECT ROUND(AVG(DATEDIFF(ExitDate, StartDate) / 365.0), 1) AS AvgTenureYears
FROM employee
WHERE ExitDate IS NOT NULL;
SELECT * FROM avg_tenure_employee;
```

**Objective:** Calculate average tenure (in years) of exited employees.

### 17. Determine which supervisor manages the most employees.

```sql
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
```

**Objective:** Identify the supervisor managing the most employees.

### 18. Identify the most common termination type by department.

```sql
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
```

**Objective:** Find the most frequent termination type per department.

### 19. List the top 5 states with the highest number of applicants.

```sql
CREATE VIEW top_state AS
SELECT State, COUNT(*) AS ApplicantCount
FROM recruitment
GROUP BY State
ORDER BY ApplicantCount DESC
LIMIT 5;
SELECT * FROM top_state;
```

**Objective:** List top 5 states with the most applicants.

### 20. Retrieve a list of applicants with more experience than the average.

```sql
CREATE TABLE exprience AS
SELECT Applicant_ID, 
       CONCAT(FirstName, ' ' ,LastName) AS Name, 
       Years_of_Experience
FROM recruitment
WHERE Years_of_Experience > (
  SELECT AVG(Years_of_Experience) FROM recruitment
);
SELECT * FROM exprience;
```

**Objective:** Retrieve applicants with more experience than the average.

### 21. Create a rolling 3-month average of engagement scores per employee.

```sql
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
```

**Objective:** Create a rolling 3-month average of engagement scores per employee.

### 22. Calculate the average training hours per employee per department and rank departments accordingly.

```sql
CREATE VIEW Avg_Hours_Per_Employee AS
SELECT 
  e.DepartmentType,
  ROUND(SUM(t.Training_Duration) / COUNT(DISTINCT e.EmpID), 2) AS Avg_Hours_Per_Employee
FROM training_development t
JOIN employee e ON e.EmpID = t.Employee_ID
GROUP BY e.DepartmentType
ORDER BY Avg_Hours_Per_Employee DESC;
SELECT * FROM Avg_Hours_Per_Employee;
```

**Objective:** Calculate and rank departments by average training hours per employee.

### 23. Identify departments where average satisfaction is below the company average.

```sql
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
```

**Objective:** Identify departments with below-average satisfaction compared to company average.

### 24. Create a list the top 3 employees in each division by current rating.

```sql
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
```

**Objective:** List top 3 employees per division based on current rating.

### 25. Build a cohort analysis of employees grouped by hiring quarter.

```sql
CREATE VIEW cohort_analysis AS
SELECT 
  CONCAT(YEAR(StartDate), '-Q', QUARTER(StartDate)) AS Hiring_Cohort,
  COUNT(*) AS Employee_Count
FROM employee
GROUP BY Hiring_Cohort
ORDER BY Hiring_Cohort;
SELECT * FROM cohort_analysis;
```

**Objective:** Group employees by hiring quarter for cohort analysis.

### 26. Find the average time between an employee's start date and their first training program.

```sql
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
```

**Objective:** Calculate average days from hire to first training program.

### 27. Calculate the average engagement score before and after completing a training program.

```sql
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
```

**Objective:** Compare average engagement scores before and after training.

### ✍️ Author - Sameer Kumar Sahu

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!




































