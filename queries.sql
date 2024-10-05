-- Human Resource analysis

-- create database
CREATE database human_resources;
USE human_resources;

-- create table
CREATE TABLE Employee(
			employee_id CHAR(255) PRIMARY KEY,
		    first_name VARCHAR(255),
			last_name VARCHAR(255),
            gender VARCHAR(255),
			state VARCHAR(255),
			city VARCHAR(255),
			education_level VARCHAR(255),
            birthdate VARCHAR(255),
			hiredate VARCHAR(255),
			termdate VARCHAR(255),
			department VARCHAR(255),
			job_title VARCHAR(255),
			salary VARCHAR(255),
			performance_rating VARCHAR(255)
            );
            
-- import data into table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/hr.csv'
INTO TABLE employee
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(employee_id, first_name, last_name, gender, state, city, education_level, birthdate, hiredate, termdate, department, job_title, salary, performance_rating);


-- OVERVIEW SUMMARY

--  number of hired employees
SELECT COUNT(employee_id) AS no_of_employees
FROM employee;

-- number of active employees
SELECT COUNT(employee_id) active_employees
FROM employee
WHERE termdate IS NULL;

-- number of terminated employees
SELECT COUNT(employee_id) terminated_employees
FROM employee
WHERE termdate IS NOT NULL ;

-- hired employees over the years
SELECT YEAR(hiredate) year,
	  COUNT(employee_id) hired_employees
FROM employee
WHERE termdate IS NULL
GROUP BY year
ORDER BY year;

-- terminated employees over the years
SELECT YEAR(hiredate) year,
	  COUNT(employee_id) terminated_employees
FROM employee
WHERE termdate IS NOT NULL
GROUP BY year
ORDER BY year;

-- employees by departments
SELECT department,
	   COUNT(employee_id) no_of_employees
FROM employee
GROUP BY department
ORDER BY no_of_employees DESC;

-- employees by job_titles
SELECT job_title,
	   COUNT(employee_id) no_of_employees
FROM employee
GROUP BY job_title
ORDER BY no_of_employees DESC;

-- number of employees at HQ(New York) vs other branches(the rest of the states)
SELECT CASE
			WHEN state = 'New York'
            THEN 'HQ'
            ELSE 'other branches'
            END
		AS branch,
	   COUNT(state) no_of_employees
FROM employee
GROUP BY branch;

-- DEMOGRAPHICS SUMMARY

-- gender ratio
SELECT CASE
		   WHEN gender = 'Male'
           THEN 'Male_employees'
           ELSE 'Female_employees'
           END
		AS gender,
       ROUND(COUNT(*) / (SELECT COUNT(*) FROM employee), 3) * 100 AS ratio
FROM employee
GROUP BY gender;

-- distribution of employees across defined age groups
SELECT CASE
		  WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) < 25 THEN '<25'
          WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) BETWEEN 25 AND 34 THEN '25-34'
          WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) BETWEEN 35 AND 44 THEN '35-44'
          WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) BETWEEN 45 AND 54 THEN '45-54'
		  ELSE '55+'
          END
	  AS age_group,
      COUNT(*) AS no_of_employees
FROM employee
GROUP BY age_group
ORDER BY no_of_employees DESC;

-- distribution of employees across education levels
SELECT education_level,
	   COUNT(*) AS no_of_employees
FROM employee
GROUP BY education_level
ORDER BY no_of_employees DESC;

-- salaries of defined age groups for both genders
SELECT CASE
		  WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) < 25 THEN '<25'
          WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) BETWEEN 25 AND 34 THEN '25-34'
          WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) BETWEEN 35 AND 44 THEN '35-44'
          WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) BETWEEN 45 AND 54 THEN '45-54'
		  ELSE '55+'
          END
	  AS age_group,
      gender,
      AVG(salary) AS avg_salary
FROM employee
GROUP BY age_group, gender
ORDER BY age_group, avg_salary DESC;


-- salaries across different education levels for both genders
SELECT education_level,
	   gender,
	   AVG(salary) AS avg_salary
FROM employee
GROUP BY education_level, gender
ORDER BY education_level;