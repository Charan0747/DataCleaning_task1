--===========================================
--Creating the Database.
--===========================================
CREATE DATABASE MedicalAppointment;

use MedicalAppointment;

--===========================================
--Creating the Table.
--===========================================

--Creating the Table and Bulk Inserting the data from CSV file to Database.
IF OBJECT_ID ('Medical_appointments','U')IS NOT NULL
	DROP TABLE Medical_appointments;
CREATE TABLE Medical_appointments(
	PatientID NVARCHAR(50),
	AppointmentID INT,
	Gender NVARCHAR(20),
	ScheduleDay NVARCHAR(25),
	AppointmentDay NVARCHAR(25),
	Age INT,
	Neighbourhood NVARCHAR(100),
	Scholarship INT,
	Hipertension INT,
	Diabetes INT,
	Alcoholism INT,
	Handcap INT,
	SMS_received INT,
	No_show NVARCHAR(10)
);
--Inserting the Raw data which  is not cleaned.
TRUNCATE TABLE Medical_appointments; -- FULL LOAD 
BULK INSERT Medical_appointments
FROM 'C:\Users\cherr\Downloads\archive 2/Medical_appointments.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	TABLOCK
);

