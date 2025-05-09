CREATE DATABASE employee_hr;
USE employee_hr;

CREATE TABLE employee
(
  EmpID	INT PRIMARY KEY, 
  FirstName VARCHAR(20),	
  LastName VARCHAR(20),	
  StartDate DATE,	
  ExitDate DATE,	
  Title VARCHAR(50),	
  Supervisor VARCHAR(30),	
  ADEmail VARCHAR(50),	
  BusinessUnit VARCHAR(10),	
  EmployeeStatus VARCHAR(20),	
  EmployeeType VARCHAR(20),	
  PayZone VARCHAR(10),
  EmployeeClassificationType VARCHAR(20),	
  TerminationType VARCHAR(20),	
  TerminationDescription VARCHAR(50),
  DepartmentType VARCHAR(20),
  ivision VARCHAR(50),	
  DOB DATE,	
  State VARCHAR (10),	
  JobFunctionDescription VARCHAR(30),	
  GenderCode VARCHAR(10),	
  LocationCode INT,	
  RaceDesc VARCHAR(20),	
  MaritalDesc VARCHAR(20),	
  Performance_Score VARCHAR(30),
  Current_Employee_Rating INT
);

CREATE TABLE employee_survay
(
 Employee_ID INT PRIMARY KEY,	
 Survey_date DATE,	
 Engagement_Score INT,	
 Satisfaction_Score INT,
 Work_Life_Balance_Score INT,
 FOREIGN KEY(Employee_id) REFERENCES employee(EmpID)
);

CREATE TABLE recruitment
(
 Applicant_ID INT,
 Application_date DATE,
 FirstName VARCHAR(20),
 LastName VARCHAR(20),
 Gender VARCHAR(10),
 dob DATE,
 PhoneNumber VARCHAR(20),	
 Email VArchar(30),
 Address VARCHAR(50),
 City VARCHAR(10),
 State VARCHAR(30),
 Zip_Code INT,
 Country varchar(20),
 Education_Level VARCHAR(30),
 Years_of_Experience float,
 Desired_Salary float,
 Job_Title varchar(30),
 Job_status varchar(30)
);

CREATE TABLE training_development
(
 Employee_ID INT PRIMARY KEY,
 Training_Date DATE,
 Training_Program_Name VARCHAR(50),
 Training_Type VARCHAR(50),
 Training_Outcome VARCHAR(20),	
 Location VARCHAR(40),
 Trainer VARCHAR(30)	,
 Training_Duration float,
 Training_Cost float,
 FOREIGN KEY(Employee_ID) REFERENCES employee(EmpID)
);

LOAD DATA LOCAL INFILE
'C:/Users/sameer kumar sahu/Desktop/New folder/employee_data.csv'
INTO TABLE employee
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from employee;

LOAD DATA LOCAL INFILE
 'C:/Users/sameer kumar sahu/Desktop/New folder/employee_engagement_survey_data.csv'
 INTO TABLE employee_survay
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from employee_survay;
 
 LOAD DATA LOCAL INFILE
 "C:/Users/sameer kumar sahu/Desktop/New folder/recruitment_data.csv"
 INTO TABLE recruitment
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from recruitment;

LOAD DATA LOCAL INFILE
 "C:/Users/sameer kumar sahu/Desktop/New folder/training_and_development_data.csv"
 INTO TABLE training_development
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from training_development;
