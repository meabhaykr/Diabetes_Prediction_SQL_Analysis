CREATE TABLE Diabetes (
    EmployeeName VARCHAR(255) PRIMARY KEY,
    Patient_id VARCHAR(255),
    gender VARCHAR(255),
    age INT,
    hypertension INT,
    heart_disease INT,
    smoking_history VARCHAR(20),
    bmi DOUBLE PRECISION,
    HbA1c_level DOUBLE PRECISION,
    blood_glucose_level INT,
    diabetes INT
);

-- FIRST VIEW
select * from Diabetes

-- 1. Retrieve the Patient_id and ages of all patients.
SELECT Patient_id age
FROM Diabetes;

-- 2. Select all female patients who are older than 40.
SELECT * FROM Diabetes
WHERE gender = 'Female' AND age > 40;

-- 3. Calculate the average BMI of patients.
SELECT AVG(bmi) AS Average_BMI FROM Diabetes;

-- 4. List patients in descending order of blood glucose levels.
SELECT EmployeeName, Patient_id, age, blood_glucose_level
FROM Diabetes
ORDER BY blood_glucose_level DESC;

-- 5. Find patients who have hypertension and diabetes.
SELECT * FROM diabetes
WHERE heart_disease = 1 AND diabetes = 1;

-- 6. Determine the number of patients with heart disease.
SELECT COUNT(patient_id) AS Heart_Patients
FROM diabetes WHERE heart_disease = 1;

-- 7. Group patients by smoking history and count how many smokers and non?smokers there are.
SELECT smoking_history, COUNT(*) AS Patient_count
FROM diabetes
WHERE smoking_history IN ('current','never')
GROUP BY 1;

-- 8. Retrieve the Patient_ids of patients who have a BMI greater than the average BMI.
SELECT patient_id
FROM diabetes
WHERE bmi > (SELECT AVG(bmi) FROM diabetes);

-- 9. Find the patient with the highest HbA1c level and the patient with the lowest HbA1clevel.
--patient with the highest HbA1c level
SELECT * FROM Diabetes
ORDER BY hbalc_level
DESC LIMIT 1;

--patient with the lowest HbA1c level
SELECT * FROM diabetes
ORDER BY hbalc_level ASC
LIMIT 1;

-- 10. Calculate the age of patients in years (assuming the current date as of now).
SELECT patient_id, age, EXTRACT (YEAR FROM CURRENT_DATE) age AS Birth_Year
FROM diabetes;

-- 11. Rank patients by blood glucose level within each gender group.
SELECT employeename as Patient_name, patient_id gender blood_glucose_level,
dense_rank () over (partition by gender order by blood_glucose_level desc) as Glucose_rank
FROM Diabetes;

-- 12. Update the smoking history of patients who are older than 50 to "Ex-smoker."
-- Start a transaction
BEGIN;
-- Update smoking history for patients older than 50 to "Ex Smoker"
UPDATE Diabetes
SET smoking_history = 'Ex Smoker'
WHERE age > 50;

-- Commit the transaction
COMMIT;

-- Select the updated records to verify
SELECT Patient_id, smoking_history, age
FROM Diabetes
WHERE age > 50;

-- 13. Insert a new patient into the database with sample data.
-- Insert a new record for Andrew Simon
INSERT INTO Diabetes (EmployeeName, Patient_id, gender, age, hypertension, heart_disease, smoking_history, bmi, HbA1c_level, blood_glucose_level, diabetes) 
VALUES ('Andrew Simon', 'PT0154235', 'Male', 54, 1, 1, 'Ex Smoker', 26.12, 6.2, 187, 1);

-- Select the inserted record to verify
SELECT * 
FROM Diabetes 
WHERE EmployeeName = 'Andrew Simon';


-- 14. Delete all patients with heart disease from the database.
-- Delete records where heart_disease is 1
DELETE FROM Diabetes 
WHERE heart_disease = 1;

-- Select remaining records to verify deletion
SELECT * 
FROM Diabetes 
WHERE heart_disease = 1;

-- 15. Find patients who have hypertension but not diabetes using the EXCEPT operator.
-- Select records where hypertension is 1, excluding those where diabetes is also 1
SELECT EmployeeName, Patient_id, hypertension, diabetes
FROM Diabetes
WHERE hypertension = 1
EXCEPT
SELECT EmployeeName, Patient_id, hypertension, diabetes
FROM Diabetes
WHERE diabetes = 1;

-- 16. Define a unique constraint on the "patient_id" column to ensure its values are unique.
ALTER TABLE diabetes ADD CONSTRAINT Unique_Patient_id UNIQUE(Patient_id);

-- 17. Create a view that displays the Patient_ids, ages, and BMI of patients.
-- Create the Patient_details view
CREATE VIEW Patient_details AS 
SELECT Patient_id, age, bmi 
FROM Diabetes;

-- Select all records from the Patient_details view to verify
SELECT * 
FROM Patient_details;