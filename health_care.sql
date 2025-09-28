-- 1. Data base Creation

create database health_care;
use health_care;

-- 2. Tables creation and established realtionship between them.
create table hospitals (
Hospital_ID varchar(10) primary key, Hospital_Name varchar(50), City varchar(100) );

create table doctors (
Doctor_ID varchar(20) primary key,	Doctor_Specialization varchar(50),	Doctor_Experience int,
Hospital_ID varchar(10), foreign key (Hospital_ID) references hospitals (Hospital_ID)
 );
 
CREATE TABLE patients (
    Patient_ID         VARCHAR(20) PRIMARY KEY,
    Patient_Age        INT,
    Patient_Gender     VARCHAR(10),
    Patient_City       VARCHAR(50),
    Doctor_ID          VARCHAR(20),
    Visit_Date         DATE,
    Patient_Disease    VARCHAR(100),
    Admission_Type     VARCHAR(20),
    Treatment_Duration INT,
    Bill_Amount        DECIMAL(10,2),
    Payment_Mode       VARCHAR(20),
    Insurance_Covered  VARCHAR(20),
    Follow_Up          INT,
    Outcome            VARCHAR(50),
    FOREIGN KEY (Doctor_ID) REFERENCES doctors(Doctor_ID)
);
SHOW VARIABLES LIKE 'datadir';

-- 3. Loading the data to the table

SET FOREIGN_KEY_CHECKS=0;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/patients.csv'
INTO TABLE patients
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET FOREIGN_KEY_CHECKS=1;


select count(*) from hospitals;
select count(*) from doctors;
select count(*) from patients;


-- 4. Handling null values
select
      sum(Hospital_ID is null) Hospital_ID_NULLs,
      sum(Hospital_Name is null) Hospital_Name_NULLs,
      sum(City is null) City_NULLs
from hospitals; 
   

select 
		sum(Doctor_ID is null) as Doctor_ID_nulls,
        sum(Doctor_Specialization is null) as Doctor_Specialization_nulls,
        sum(Doctor_Experience  is null) as Doctor_Experience_nulls,
        sum(Hospital_ID is null) as Hospital_ID_nulls
from doctors;
        

select * from Patients;
select 
      sum(Patient_ID is null) as Patient_ID_nulls,
	  sum(Patient_Age is null) as Patient_Age_nulls,
      sum(Patient_Gender is null) as Patient_Gender_nulls,
      sum(Patient_City is null) as Patient_City_nulls,
      sum(Visit_Date is null) as Visit_Date_nulls,
      sum(Patient_Disease is null) as Patient_Disease_nulls,
	  sum(Admission_Type is null) as Admission_Type_nulls,
      sum(Treatment_Duration is null) as Treatment_Duration_nulls,
      sum(Bill_Amount is null) as Bill_Amount_nulls,
      sum(Payment_Mode is null) as Payment_Mode_nulls,
      sum(Insurance_Covered is null) as Payment_Mode_nulls,
      sum(Follow_Up is null) as Follow_Up_nulls,
      sum(Outcome is null) as Outcome_nulls
from patients;

   -- All columns in these tables have no null values, except for the 
   -- Follow_Up column in the patients table, which contains 87,705 null values.
   

WITH follow AS (
    SELECT 
        Patient_Disease, 
        ROUND(AVG(Follow_Up), 0) AS follow_Up
    FROM Patients
    GROUP BY Patient_Disease
)
UPDATE Patients P
JOIN follow f
    ON P.Patient_Disease = f.Patient_Disease
    
SET P.Follow_Up = f.follow_Up
WHERE P.Follow_Up IS NULL;


-- Null values got updated, No null values pending 




   
-- 5. Check For Duplicates 
SELECT Hospital_ID, COUNT(*) AS Dupes
FROM hospitals
GROUP BY Hospital_ID
HAVING COUNT(*) > 1;

SELECT Doctor_ID, COUNT(*) AS Dupes
FROM doctors
GROUP BY Doctor_ID
HAVING COUNT(*) > 1;

SELECT Patient_ID, COUNT(*) AS Dupes
FROM patients
GROUP BY Patient_ID
HAVING COUNT(*) > 1;

  -- No duplicates in three tables 
  
-- 6. Checking table data types 
  desc hospitals;
  desc doctors;
  desc patients;
  
  -- All columns were in correct data types
  
-- 7. Validating The Data
SELECT * FROM patients WHERE Treatment_Duration < 0;
SELECT * FROM patients WHERE Patient_Age < 0 OR Patient_Age > 120;

UPDATE patients SET Patient_City = TRIM(Patient_City);
UPDATE hospitals SET Hospital_Name = TRIM(Hospital_Name);

-- 

select * from hospitals;
select * from patients;
select * from doctors;


-- 8. Adding additional Columns 

select * from doctors;
ALTER TABLE doctors
ADD COLUMN Experience_Level VARCHAR(20);
set sql_safe_updates = 0;

update doctors
set Experience_Level = case
when Doctor_Experience <=3 then 'Junior'
when Doctor_Experience > 3 and Doctor_Experience <= 10 then 'Experienced'
else 'Expert'
end;

select * from patients;

alter table patients
add column Age_Groups varchar(20);


update patients
set Age_Groups = case 
when Patient_Age < 18 then 'Child'
when Patient_Age > 18 and Patient_Age <=30 then 'Youth'
when Patient_Age >30 and Patient_Age < 60 then 'Midlle_Age'
else 'Old_Age'
end;

select Admission_type, Count(*) from patients
group by Admission_type;

ALTER TABLE patients
ADD COLUMN Visit_Month VARCHAR(20);

set sql_safe_updates = 0;

UPDATE patients
SET Visit_Month = MONTHNAME(Visit_Date);

select * from patients;


-- Done .