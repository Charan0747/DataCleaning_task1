--==========================
--Data Cleaning Process.
--===========================

--For Patient ID
UPDATE Medical_appointments
SET PatientID = REPLACE(PatientID, ',', '');

UPDATE Medical_appointments
SET PatientID = CASE WHEN RIGHT(PatientID,2) = '.0'
                     THEN LEFT(PatientID, LEN(PatientID)-2)
                     ELSE PatientID END;

SELECT DISTINCT PatientID
FROM Medical_appointments
WHERE TRY_CAST(PatientID AS BIGINT) IS NULL;

UPDATE Medical_appointments
SET PatientID = '14172416655'   -- correct fixed value
WHERE PatientID = '14172416655E-5';

UPDATE Medical_appointments
SET PatientID = '3921784439'   -- correct fixed value
WHERE PatientID = '3921784439E-5';

UPDATE Medical_appointments
SET PatientID = '4374175652'   -- correct fixed value
WHERE PatientID = '4374175652E-5';

UPDATE Medical_appointments
SET PatientID = '53761528476'   -- correct fixed value
WHERE PatientID = '53761528476E-5';

UPDATE Medical_appointments
SET PatientID = '9377952927'   -- correct fixed value
WHERE PatientID = '9377952927E-5';

ALTER TABLE Medical_appointments
ALTER COLUMN PatientID BIGINT;

--For Gender
UPDATE Medical_appointments
SET Gender = CASE 
                WHEN Gender = 'M' THEN 'Male'
                WHEN Gender = 'F' THEN 'Female'
                ELSE 'N/A'
             END;

-- For ScheduleDay and AppointmentDay
UPDATE Medical_appointments
SET ScheduleDay = CONVERT(DATETIME, REPLACE(ScheduleDay, 'Z', ''), 126);

UPDATE Medical_appointments
SET AppointmentDay = CONVERT(DATE, REPLACE(AppointmentDay, 'Z', ''), 126);

ALTER TABLE Medical_appointments ADD DaysWait INT;

UPDATE Medical_appointments
SET DaysWait = DATEDIFF(DAY, CAST(ScheduleDay AS DATE), AppointmentDay);

-- For Age 
UPDATE Medical_Appointments
SET Age = CASE 
            WHEN Age < 0 THEN 0
            ELSE Age
          END;

--Neighbourhood
Update Medical_Appointments
SET Neighbourhood = TRIM(Neighbourhood);

--For Remainig Colums 
ALTER TABLE Medical_appointments ALTER COLUMN Scholarship NVARCHAR(3);
ALTER TABLE Medical_appointments ALTER COLUMN Hipertension NVARCHAR(3);
ALTER TABLE Medical_appointments ALTER COLUMN Diabetes NVARCHAR(3);
ALTER TABLE Medical_appointments ALTER COLUMN Alcoholism NVARCHAR(3);
ALTER TABLE Medical_appointments ALTER COLUMN Handcap NVARCHAR(3);
ALTER TABLE Medical_appointments ALTER COLUMN SMS_received NVARCHAR(3);

-- Scholarship
UPDATE Medical_appointments
SET Scholarship = CASE 
                     WHEN Scholarship = 1 THEN 'Yes' 
                     ELSE 'No' 
                  END;

-- Hypertension
UPDATE Medical_appointments
SET Hipertension = CASE 
                      WHEN Hipertension = 1 THEN 'Yes' 
                      ELSE 'No' 
                   END;
--Diabetes
UPDATE Medical_appointments
SET Diabetes = CASE 
                      WHEN Diabetes = 1 THEN 'Yes' 
                      ELSE 'No' 
                   END;
--Alcoholism
UPDATE Medical_appointments
SET Alcoholism = CASE 
                      WHEN Alcoholism = 1 THEN 'Yes' 
                      ELSE 'No' 
                   END;
--Handcap
UPDATE Medical_appointments
SET Handcap = CASE 
                      WHEN Handcap = 1 THEN 'Yes' 
                      ELSE 'No' 
                   END;
--SMS_received
UPDATE Medical_appointments
SET SMS_received = CASE 
                      WHEN SMS_received = 1 THEN 'Yes' 
                      ELSE 'No' 
                   END;

--No_Show
UPDATE Medical_appointments
SET No_show = TRIM(No_show);



--Checking NULLS and Constraints
SELECT *
FROM Medical_appointments_cleaned
WHERE AppointmentID IS NULL;

SELECT AppointmentID, COUNT(*)
FROM Medical_appointments_cleaned
GROUP BY AppointmentID
HAVING COUNT(*) > 1;

