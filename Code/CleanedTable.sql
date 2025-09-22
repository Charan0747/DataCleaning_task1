-- =========================================
-- CREATE CLEANED TABLE WITH CONSTRAINTS
-- =========================================

-- Drop table if it already exists (safety)
IF OBJECT_ID('dbo.Medical_appointments_cleaned', 'U') IS NOT NULL
    DROP TABLE dbo.Medical_appointments_cleaned;

-- 1. Create new table with cleaned data
SELECT
    -- PatientID cleanup
    CAST(
        CASE 
            WHEN PatientID LIKE '%,%' THEN REPLACE(PatientID, ',', '')
            WHEN RIGHT(PatientID, 2) = '.0' THEN LEFT(PatientID, LEN(PatientID) - 2)
            WHEN PatientID = '14172416655E-5' THEN '14172416655'
            WHEN PatientID = '3921784439E-5' THEN '3921784439'
            WHEN PatientID = '4374175652E-5' THEN '4374175652'
            WHEN PatientID = '53761528476E-5' THEN '53761528476'
            WHEN PatientID = '9377952927E-5' THEN '9377952927'
            ELSE PatientID
        END AS BIGINT
    ) AS PatientID,

    AppointmentID,

    -- Gender cleanup
    CASE 
        WHEN Gender = 'M' THEN 'Male'
        WHEN Gender = 'F' THEN 'Female'
        ELSE 'N/A'
    END AS Gender,

    -- Dates cleanup
    CONVERT(DATETIME, REPLACE(ScheduleDay, 'Z', ''), 126) AS ScheduledDay,
    CONVERT(DATE, REPLACE(AppointmentDay, 'Z', ''), 126) AS AppointmentDay,

    -- DaysWait calculation
    DATEDIFF(
        DAY,
        CAST(CONVERT(DATETIME, REPLACE(ScheduleDay, 'Z', ''), 126) AS DATE),
        CONVERT(DATE, REPLACE(AppointmentDay, 'Z', ''), 126)
    ) AS DaysWait,

    -- Age cleanup
    CASE 
        WHEN Age < 0 THEN 0
        ELSE Age
    END AS Age,

    -- Neighbourhood cleanup
    LTRIM(RTRIM(Neighbourhood)) AS Neighbourhood,

    -- Binary flags as Yes/No
    CASE WHEN Scholarship = 1 THEN 'Yes' ELSE 'No' END AS Scholarship,
    CASE WHEN Hipertension = 1 THEN 'Yes' ELSE 'No' END AS Hypertension,
    CASE WHEN Diabetes = 1 THEN 'Yes' ELSE 'No' END AS Diabetes,
    CASE WHEN Alcoholism = 1 THEN 'Yes' ELSE 'No' END AS Alcoholism,
    CASE WHEN Handcap = 1 THEN 'Yes' ELSE 'No' END AS Handicap,
    CASE WHEN SMS_received = 1 THEN 'Yes' ELSE 'No' END AS SMS_received,

    -- No_show cleanup
    LTRIM(RTRIM(No_show)) AS No_show

INTO dbo.Medical_appointments_cleaned
FROM dbo.Medical_appointments;

-- 2. Apply constraints to keep new data clean
ALTER TABLE Medical_appointments_cleaned
ALTER COLUMN AppointmentID INT NOT NULL;

ALTER TABLE dbo.Medical_appointments_cleaned
ADD CONSTRAINT PK_MedicalAppointmentsCleaned PRIMARY KEY (AppointmentID);

ALTER TABLE dbo.Medical_appointments_cleaned
ADD CONSTRAINT CK_Age_NonNegative CHECK (Age >= 0);

ALTER TABLE dbo.Medical_appointments_cleaned
ADD CONSTRAINT CK_Gender_Valid CHECK (Gender IN ('Male', 'Female', 'N/A'));


ALTER TABLE dbo.Medical_appointments_cleaned
ADD CONSTRAINT CK_Scholarship_Valid CHECK (Scholarship IN ('Yes','No'));

ALTER TABLE dbo.Medical_appointments_cleaned
ADD CONSTRAINT CK_Hypertension_Valid CHECK (Hypertension IN ('Yes','No'));

ALTER TABLE dbo.Medical_appointments_cleaned
ADD CONSTRAINT CK_Diabetes_Valid CHECK (Diabetes IN ('Yes','No'));

ALTER TABLE dbo.Medical_appointments_cleaned
ADD CONSTRAINT CK_Alcoholism_Valid CHECK (Alcoholism IN ('Yes','No'));

ALTER TABLE dbo.Medical_appointments_cleaned
ADD CONSTRAINT CK_Handicap_Valid CHECK (Handicap IN ('Yes','No'));

ALTER TABLE dbo.Medical_appointments_cleaned
ADD CONSTRAINT CK_SMSReceived_Valid CHECK (SMS_received IN ('Yes','No'));

ALTER TABLE dbo.Medical_appointments_cleaned
ADD CONSTRAINT CK_NoShow_Valid CHECK (No_show IN ('Yes','No'));
