-- Create the Hospital database
CREATE DATABASE Hospital;

-- Use the Hospital database
USE Hospital;

-- ========================
-- TABLES
-- ========================

-- Create Rooms table
CREATE TABLE Rooms (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each room
  room_number VARCHAR(20) UNIQUE NOT NULL, -- Physical room number (must be unique)
  room_type VARCHAR(50) NOT NULL, -- Type of room (e.g., General, ICU, Private)
  status VARCHAR(20) NOT NULL, -- Occupancy status (e.g., Vacant, Occupied)
  daily_charge DECIMAL(10, 2) NOT NULL -- Daily cost for using the room
);

-- Create Doctors table
CREATE TABLE Doctors (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each doctor
  first_name VARCHAR(100) NOT NULL, -- First name of the doctor
  last_name VARCHAR(100) NOT NULL, -- Last name of the doctor
  specialization VARCHAR(100) NOT NULL, -- Specialization of each doctor
  contact_number VARCHAR(20) NOT NULL, -- Contact number of the doctor
  email VARCHAR(100) UNIQUE NOT NULL, -- Email address of the doctor (must be unique)
  room_id INT NOT NULL, -- FK to Rooms table (assigned consulting room)
  FOREIGN KEY (room_id) REFERENCES Rooms(id) -- Foreign key to Rooms table
);

-- Create Patients table
CREATE TABLE Patients (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each patient
  first_name VARCHAR(100) NOT NULL, -- First name of the patient
  last_name VARCHAR(100) NOT NULL, -- Last name of the patient
  date_of_birth DATE NOT NULL, -- Birth date of the patient
  gender VARCHAR(10) NOT NULL, -- Gender of the patient
  contact_number VARCHAR(20) NOT NULL, -- Contact number of the patient
  email VARCHAR(100) UNIQUE NOT NULL, -- Email address of the patient (must be unique)
  residential_address VARCHAR(255) NOT NULL, -- Residential address of the patient
  admission_date DATE NOT NULL, -- Admission date of the patient
  discharge_date DATE, -- Discharge date of the patient (nullable as not discharged yet)
  room_id INT, -- FK to Rooms table (nullable, as patient may not be assigned to a room)
  doctor_id INT, -- FK to Doctors table (nullable, as patient may not yet have a doctor assigned)
  FOREIGN KEY (room_id) REFERENCES Rooms(id), -- Foreign key to Rooms table
  FOREIGN KEY (doctor_id) REFERENCES Doctors(id) -- Foreign key to Doctors table
);

-- Create BillReports table
CREATE TABLE BillReports (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each bill report
  patient_id INT NOT NULL, -- FK to Patients table
  issue_date DATE NOT NULL, -- Date when the bill was generated
  amount DECIMAL(10, 2) NOT NULL, -- Total cost of services (cannot be null)
  payment_status VARCHAR(20) NOT NULL, -- Payment status (e.g., Paid, Unpaid, Pending)
  payment_method VARCHAR(20) NOT NULL, -- Method of payment (e.g., cash, card)
  FOREIGN KEY (patient_id) REFERENCES Patients(id) -- Foreign key to Patients table
);

-- Create Services table
CREATE TABLE Services (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each service
  name VARCHAR(100) NOT NULL, -- Name of the service (e.g., X-Ray, Surgery)
  description VARCHAR(255), -- Description of the service (nullable, in case description is not provided)
  cost DECIMAL(10, 2) NOT NULL, -- Cost of the service (cannot be null)
  patient_id INT NOT NULL, -- FK to Patients table (service is provided to a patient)
  doctor_id INT NOT NULL, -- FK to Doctors table (doctor providing the service)
  FOREIGN KEY (patient_id) REFERENCES Patients(id), -- Foreign key to Patients table
  FOREIGN KEY (doctor_id) REFERENCES Doctors(id) -- Foreign key to Doctors table
);

-- Create Consultations table
CREATE TABLE Consultations (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each consultation
  patient_id INT NOT NULL, -- FK to Patients table
  doctor_id INT NOT NULL, -- FK to Doctors table
  date DATETIME NOT NULL, -- Date and time of the consultation
  notes VARCHAR(255), -- Notes about the consultation (nullable, in case no notes are added)
  prescription VARCHAR(255), -- Prescribed medicine and treatments (nullable, in case no prescription is made)
  FOREIGN KEY (patient_id) REFERENCES Patients(id), -- Foreign key to Patients table
  FOREIGN KEY (doctor_id) REFERENCES Doctors(id) -- Foreign key to Doctors table
);

-- ========================
-- TRIGGERS
-- ========================

-- 		This trigger is responsible for updating the room status
-- 		after the patient has been admissed. The status is changed 
--      from "Vacant" to "Occupied".
DELIMITER //

CREATE TRIGGER update_room_status_after_patient_admission
AFTER INSERT ON Patients
FOR EACH ROW
BEGIN
  IF NEW.room_id IS NOT NULL THEN
    UPDATE Rooms 
    SET status = 'Occupied' 
    WHERE id = NEW.room_id;
  END IF;
END;

//

-- 		This trigger is responsible for updating the room status
-- 		after the patient has been dismissed. The status is changed 
--      from "Occupied" to "Vacant".
CREATE TRIGGER update_room_status_after_patient_discharge
AFTER UPDATE ON Patients
FOR EACH ROW
BEGIN
  IF NEW.discharge_date IS NOT NULL AND OLD.discharge_date IS NULL THEN
    UPDATE Rooms 
    SET status = 'Vacant' 
    WHERE id = NEW.room_id;
  END IF;
END;

//
DELIMITER ;

DELIMITER //

-- 		This trigger is responsible for generating a BillReport 
-- 	    for the patient. The total days charge is being calculated 
--      and the services are taken into account as well.
CREATE TRIGGER generate_bill_on_discharge
AFTER UPDATE ON Patients
FOR EACH ROW
BEGIN
  -- Check if the patient is being discharged
  IF NEW.discharge_date IS NOT NULL AND OLD.discharge_date IS NULL THEN

    -- Calculate number of days stayed
    SET @total_days = DATEDIFF(NEW.discharge_date, NEW.admission_date);
    
    -- Get the daily room charge
    SET @room_charge = (
      SELECT daily_charge 
      FROM Rooms 
      WHERE id = NEW.room_id
    );

    -- Calculate total services cost for the patient
    SET @total_services_cost = (
      SELECT IFNULL(SUM(cost), 0) 
      FROM Services 
      WHERE patient_id = NEW.id
    );

    -- Insert the bill report
    INSERT INTO BillReports (patient_id, issue_date, amount, payment_status, payment_method)
    VALUES (
      NEW.id, 
      NOW(), 
      (@total_days * @room_charge) + @total_services_cost, 
      'Pending', 
      'N/A'
    );

  END IF;
END;

//
DELIMITER ;

DELIMITER //
-- 		This trigger is responsible for ensuring a unique room
-- 	    assignment for each doctor. Again, when a room is assigned
--      to a doctor, the status will be "Occupied", otherwise it
--      will be set to "Vacant"
CREATE TRIGGER ensure_unique_room_assignment
BEFORE UPDATE ON Doctors
FOR EACH ROW
BEGIN
  IF NEW.room_id <> OLD.room_id THEN
    -- Remove the doctor from the previous room
    UPDATE Rooms 
    SET status = 'Vacant' 
    WHERE id = OLD.room_id;

    -- Mark the new room as occupied (optional, as this is handled by the patient trigger)
    UPDATE Rooms 
    SET status = 'Occupied' 
    WHERE id = NEW.room_id;
  END IF;
END;

//
DELIMITER ;

DELIMITER //
--      This trigger is responsible for ensurtings cascading cleanup 
--      when a Patient is deleted. When a patient is deleted from the 
--      Patients table, the associated services, bills and colsuntations
-- 	    are also going to be deleted
CREATE TRIGGER delete_patient_cascade
AFTER DELETE ON Patients
FOR EACH ROW
BEGIN
  -- Delete all services related to the deleted patient
  DELETE FROM Services 
  WHERE patient_id = OLD.id;

  -- Delete all bill reports related to the deleted patient
  DELETE FROM BillReports 
  WHERE patient_id = OLD.id;

  -- Delete all consultations related to the deleted patient
  DELETE FROM Consultations 
  WHERE patient_id = OLD.id;
END;

//
DELIMITER ;

-- ========================
-- INDEXES
-- ========================

CREATE UNIQUE INDEX idx_room_number ON Rooms (room_number);
CREATE INDEX idx_room_status ON Rooms (status);
CREATE INDEX idx_room_type ON Rooms (room_type);

CREATE UNIQUE INDEX idx_doctor_email ON Doctors (email);
CREATE INDEX idx_doctor_specialization ON Doctors (specialization);
CREATE INDEX idx_doctor_contact ON Doctors (contact_number);
CREATE INDEX idx_doctor_room_id ON Doctors (room_id);

CREATE UNIQUE INDEX idx_patient_email ON Patients (email);
CREATE INDEX idx_patient_contact ON Patients (contact_number);
CREATE INDEX idx_patient_discharge_date ON Patients (discharge_date);
CREATE INDEX idx_patient_admission_date ON Patients (admission_date);
CREATE INDEX idx_patient_room_id ON Patients (room_id);
CREATE INDEX idx_patient_doctor_id ON Patients (doctor_id);

CREATE INDEX idx_bill_patient_id ON BillReports (patient_id);
CREATE INDEX idx_bill_issue_date ON BillReports (issue_date);
CREATE INDEX idx_bill_payment_status ON BillReports (payment_status);

CREATE INDEX idx_service_patient_id ON Services (patient_id);
CREATE INDEX idx_service_doctor_id ON Services (doctor_id);
CREATE INDEX idx_service_name ON Services (name);

CREATE INDEX idx_consultation_patient_id ON Consultations (patient_id);
CREATE INDEX idx_consultation_doctor_id ON Consultations (doctor_id);
CREATE INDEX idx_consultation_date ON Consultations (date);

-- ========================
-- ROLES
-- ========================

CREATE ROLE Admin;
CREATE ROLE Doctor;
CREATE ROLE BillingStaff;
CREATE ROLE Patient;

-- Grant Privileges to Admin
GRANT ALL PRIVILEGES ON Hospital.* TO 'Admin';

-- Grant Privileges to Doctor
GRANT SELECT, UPDATE ON Hospital.Patients TO 'Doctor';
GRANT SELECT, INSERT, UPDATE ON Hospital.Consultations TO 'Doctor';
GRANT SELECT, INSERT ON Hospital.Services TO 'Doctor';

-- Grant Privileges to Billing Staff
GRANT SELECT, INSERT, UPDATE ON Hospital.BillReports TO 'BillingStaff';
GRANT SELECT ON Hospital.Patients TO 'BillingStaff';
GRANT SELECT, UPDATE ON Hospital.Services TO 'BillingStaff';

-- Grant Privileges to Patient
GRANT SELECT ON Hospital.Patients TO 'Patient';
GRANT SELECT ON Hospital.BillReports TO 'Patient';
GRANT SELECT ON Hospital.Consultations TO 'Patient';

CREATE USER Admnistrator;
GRANT Admin to Admnistrator;

CREATE USER DoctorAcc;
GRANT Doctor to DoctorAcc;

CREATE USER FinancialAcc;
GRANT BillingStaff to FinancialAcc;

CREATE USER PatientAcc;
GRANT Patient to PatientAcc;



-- ========================
-- VIEWS
-- ========================

-- View 1: View for Patient Medical History
CREATE VIEW PatientMedicalHistory AS
SELECT 
    p.id AS PatientID, 
    CONCAT(p.first_name, ' ', p.last_name) AS PatientName, 
    p.date_of_birth, 
    p.gender, 
    p.admission_date, 
    p.discharge_date, 
    c.date AS ConsultationDate, 
    c.notes AS ConsultationNotes, 
    c.prescription 
FROM 
    Patients p
LEFT JOIN 
    Consultations c ON p.id = c.patient_id;

-- View 2: View for Doctor Workload
CREATE VIEW DoctorWorkload AS
SELECT 
    d.id AS DoctorID, 
    CONCAT(d.first_name, ' ', d.last_name) AS DoctorName, 
    d.specialization, 
    COUNT(c.id) AS TotalConsultations, 
    COUNT(s.id) AS TotalServicesProvided 
FROM 
    Doctors d
LEFT JOIN 
    Consultations c ON d.id = c.doctor_id
LEFT JOIN 
    Services s ON d.id = s.doctor_id
GROUP BY 
    d.id;

-- View 3: View for Outstanding Bills
CREATE VIEW OutstandingBills AS
SELECT 
    b.id AS BillID, 
    CONCAT(p.first_name, ' ', p.last_name) AS PatientName, 
    b.issue_date, 
    b.amount, 
    b.payment_status 
FROM 
    BillReports b
JOIN 
    Patients p ON b.patient_id = p.id
WHERE 
    b.payment_status = 'Unpaid';

-- ========================
-- STORED PROCEDURES
-- ========================

-- Stored Procedure 1: Add a New Patient
DELIMITER //
CREATE PROCEDURE AddNewPatient(
    IN firstName VARCHAR(100), 
    IN lastName VARCHAR(100), 
    IN dob DATE, 
    IN gender VARCHAR(10), 
    IN contact VARCHAR(20), 
    IN email VARCHAR(100), 
    IN address VARCHAR(255), 
    IN admissionDate DATE
)
BEGIN
    INSERT INTO Patients (
        first_name, 
        last_name, 
        date_of_birth, 
        gender, 
        contact_number, 
        email, 
        residential_address, 
        admission_date
    ) 
    VALUES 
    (
        firstName, 
        lastName, 
        dob, 
        gender, 
        contact, 
        email, 
        address, 
        admissionDate
    );
END;
//
DELIMITER ;

-- Stored Procedure 2: Update Patient Discharge Date
DELIMITER //
CREATE PROCEDURE UpdatePatientDischargeDate(
    IN patientID INT, 
    IN dischargeDate DATE
)
BEGIN
    UPDATE Patients 
    SET discharge_date = dischargeDate 
    WHERE id = patientID;
END;
//
DELIMITER ;

-- Stored Procedure 3: Generate Bill for a Patient
DELIMITER //
CREATE PROCEDURE GenerateBill(
    IN patientID INT
)
BEGIN
    DECLARE totalDays INT;
    DECLARE roomCharge DECIMAL(10, 2);
    DECLARE totalServiceCost DECIMAL(10, 2);
    
    SELECT  DATEDIFF(CURDATE(), admission_date) 
    INTO totalDays 
    FROM Patients 
    WHERE id = patientID;
    
    SELECT daily_charge INTO roomCharge 
    FROM Rooms 
    WHERE id = (SELECT room_id FROM Patients WHERE id = patientID);
    
    SELECT IFNULL(SUM(cost), 0) 
    INTO totalServiceCost 
    FROM Services 
    WHERE patient_id = patientID;
    
    INSERT INTO BillReports (
        patient_id, 
        issue_date, 
        amount, 
        payment_status, 
        payment_method
    ) 
    VALUES 
    (
        patientID, 
        CURDATE(), 
        (totalDays * roomCharge) + totalServiceCost, 
        'Unpaid', 
        'N/A' 
    );
END;
//
DELIMITER ;

-- Enable event scheduler (only if not already enabled)
SET GLOBAL event_scheduler = ON;

-- Create an event to delete old bill reports
CREATE EVENT ClearOldBillReports
ON SCHEDULE EVERY 1 YEAR
STARTS CURRENT_DATE + INTERVAL 1 YEAR
DO
DELETE FROM BillReports 
WHERE issue_date < CURDATE() - INTERVAL 2 YEAR;


-- ========================
-- INSERT ROOMS
-- ========================
INSERT INTO Rooms (room_number, room_type, status, daily_charge) VALUES 
('101', 'General', 'Vacant', 100.00),
('102', 'ICU', 'Occupied', 500.00),
('103', 'Private', 'Occupied', 300.00),
('104', 'General', 'Vacant', 120.00),
('105', 'ICU', 'Vacant', 550.00);

-- ========================
-- INSERT DOCTORS
-- ========================
INSERT INTO Doctors (first_name, last_name, specialization, contact_number, email, room_id) VALUES 
('John', 'Doe', 'Cardiology', '1234567890', 'john.doe@example.com', 1),
('Sarah', 'Smith', 'Neurology', '2345678901', 'sarah.smith@example.com', 2),
('Michael', 'Brown', 'Orthopedics', '3456789012', 'michael.brown@example.com', 3),
('Emily', 'Davis', 'Pediatrics', '4567890123', 'emily.davis@example.com', 4),
('David', 'Wilson', 'General Surgery', '5678901234', 'david.wilson@example.com', 5);

-- ========================
-- INSERT PATIENTS
-- ========================
INSERT INTO Patients (first_name, last_name, date_of_birth, gender, contact_number, email, residential_address, admission_date, discharge_date, room_id, doctor_id) VALUES 
('Alice', 'Johnson', '1987-05-12', 'Female', '6789012345', 'alice.johnson@example.com', '123 Main St, Cityville', '2024-11-15', '2024-12-01', 2, 1),
('Bob', 'Miller', '1990-07-22', 'Male', '7890123456', 'bob.miller@example.com', '456 Elm St, Townsville', '2024-12-10', NULL, 3, 2),
('Charlie', 'Garcia', '1975-02-09', 'Male', '8901234567', 'charlie.garcia@example.com', '789 Oak St, Villageburg', '2024-12-01', NULL, 1, 3),
('Diana', 'Martinez', '2001-10-15', 'Female', '9012345678', 'diana.martinez@example.com', '321 Pine St, Hamletton', '2024-12-12', NULL, 4, 4),
('Ethan', 'Hernandez', '1995-12-25', 'Male', '1230984567', 'ethan.hernandez@example.com', '654 Maple St, Metrocity', '2024-11-20', '2024-12-05', 3, 5);

-- ========================
-- INSERT BILL REPORTS
-- ========================
INSERT INTO BillReports (patient_id, issue_date, amount, payment_status, payment_method) VALUES 
(1, '2024-12-02', 1500.00, 'Paid', 'Credit Card'),
(2, '2024-12-15', 1200.00, 'Unpaid', 'N/A'),
(3, '2024-12-05', 1000.00, 'Paid', 'Cash'),
(4, '2024-12-13', 900.00, 'Pending', 'N/A'),
(5, '2024-12-06', 1800.00, 'Paid', 'Credit Card');

-- ========================
-- INSERT SERVICES
-- ========================
INSERT INTO Services (name, description, cost, patient_id, doctor_id) VALUES 
('X-Ray', 'Chest X-ray for diagnostic purposes', 200.00, 1, 1),
('MRI Scan', 'Brain MRI for neurological analysis', 1500.00, 2, 2),
('Physiotherapy', 'Therapy for back pain', 300.00, 3, 3),
('Vaccination', 'Routine vaccination', 50.00, 4, 4),
('Minor Surgery', 'Removal of a cyst', 1200.00, 5, 5),
('Blood Test', 'Complete blood count', 100.00, 1, 1),
('CT Scan', 'Full body CT scan', 2000.00, 2, 2),
('Bone Scan', 'Bone density analysis', 800.00, 3, 3),
('Child Immunization', 'Childhood immunization schedule', 150.00, 4, 4),
('Endoscopy', 'Internal examination using endoscope', 2500.00, 5, 5);

-- ========================
-- INSERT CONSULTATIONS
-- ========================
INSERT INTO Consultations (patient_id, doctor_id, date, notes, prescription) VALUES 
(1, 1, '2024-11-16 09:00:00', 'Initial consultation for chest pain', 'Painkillers, rest for 7 days'),
(2, 2, '2024-12-10 10:30:00', 'Neurological examination for headaches', 'MRI scan recommended'),
(3, 3, '2024-12-02 14:00:00', 'Back pain complaint, suggested physiotherapy', 'Physiotherapy sessions'),
(4, 4, '2024-12-12 11:00:00', 'Vaccination for flu', 'Seasonal flu vaccine administered'),
(5, 5, '2024-11-21 15:00:00', 'Initial examination for minor cyst', 'Scheduled minor surgery'),
(1, 1, '2024-11-20 09:00:00', 'Follow-up consultation for chest pain', 'No further medication required'),
(2, 2, '2024-12-12 12:00:00', 'Review of MRI scan results', 'Follow-up consultation required'),
(3, 3, '2024-12-05 16:00:00', 'Progress review after physiotherapy sessions', 'Continue therapy for 2 more weeks'),
(4, 4, '2024-12-14 10:00:00', 'Check-up after vaccination', 'No further action required'),
(5, 5, '2024-12-03 13:30:00', 'Pre-surgery consultation', 'Confirmed surgery date and procedure');

-- ========================
-- DATABASE TESTING
-- ========================

-- ✅ Test valid room insertion
INSERT INTO Rooms (room_number, room_type, status, daily_charge) 
VALUES ('201', 'General', 'Vacant', 150.00); 

-- ❌ Test duplicate room number (violates UNIQUE constraint)
INSERT INTO Rooms (room_number, room_type, status, daily_charge) 
VALUES ('201', 'ICU', 'Occupied', 500.00); 

-- ❌ Test insertion with NULL for NOT NULL columns
INSERT INTO Rooms (room_number, room_type, status, daily_charge) 
VALUES (NULL, 'General', 'Vacant', 100.00);


-- ✅ Test valid doctor insertion
INSERT INTO Doctors (first_name, last_name, specialization, contact_number, email, room_id) 
VALUES ('William', 'Taylor', 'Dermatology', '9998887776', 'william.taylor@example.com', 1); 

-- ❌ Test invalid email (violates UNIQUE constraint)
INSERT INTO Doctors (first_name, last_name, specialization, contact_number, email, room_id) 
VALUES ('Sarah', 'Smith', 'Cardiology', '8887776665', 'john.doe@example.com', 1); 

-- ❌ Test insertion of doctor with non-existing room_id (violates FK constraint)
INSERT INTO Doctors (first_name, last_name, specialization, contact_number, email, room_id) 
VALUES ('Luke', 'Adams', 'Oncology', '5554443332', 'luke.adams@example.com', 999);


-- ✅ Test valid patient insertion
INSERT INTO Patients (first_name, last_name, date_of_birth, gender, contact_number, email, residential_address, admission_date, discharge_date, room_id, doctor_id) 
VALUES ('Sophia', 'Moore', '1998-03-15', 'Female', '8765432109', 'sophia.moore@example.com', '789 Cedar St', '2024-12-01', NULL, 1, 1); 

-- ❌ Test patient insertion with non-existing room_id (violates FK constraint)
INSERT INTO Patients (first_name, last_name, date_of_birth, gender, contact_number, email, residential_address, admission_date, discharge_date, room_id, doctor_id) 
VALUES ('Evelyn', 'Anderson', '2000-08-21', 'Female', '8765432109', 'evelyn.anderson@example.com', '123 Birch St', '2024-12-01', NULL, 999, 1);


-- Delete a doctor, expect related consultations and services to be deleted
DELETE FROM Doctors WHERE id = 1;

-- Check if services and consultations related to this doctor are deleted
SELECT * FROM Services WHERE doctor_id = 1; -- Should return no records
SELECT * FROM Consultations WHERE doctor_id = 1; -- Should return no records


-- Select from the view that lists active patients
SELECT * FROM OutstandingBills; 



-- Drop existing foreign key constraints
ALTER TABLE BillReports
  DROP FOREIGN KEY billreports_ibfk_1;

ALTER TABLE Services
  DROP FOREIGN KEY services_ibfk_1;

ALTER TABLE Consultations
  DROP FOREIGN KEY consultations_ibfk_1;

-- Add new foreign key constraints with ON DELETE CASCADE
ALTER TABLE BillReports
  ADD CONSTRAINT billreports_ibfk_1 FOREIGN KEY (patient_id) REFERENCES Patients(id) ON DELETE CASCADE;

ALTER TABLE Services
  ADD CONSTRAINT services_ibfk_1 FOREIGN KEY (patient_id) REFERENCES Patients(id) ON DELETE CASCADE;

ALTER TABLE Consultations
  ADD CONSTRAINT consultations_ibfk_1 FOREIGN KEY (patient_id) REFERENCES Patients(id) ON DELETE CASCADE;




-- Insert a sample patient
INSERT INTO Patients (first_name, last_name, date_of_birth, gender, contact_number, email, residential_address, admission_date, discharge_date, room_id, doctor_id) 
VALUES ('Alice', 'Smith', '1990-07-15', 'Female', '9876543210', 'alice.smith@example.com', '789 Maple St', '2024-12-10', NULL, 1, NULL);

-- Get the patient ID for Alice
SELECT id FROM Patients WHERE email = 'alice.smith@example.com';

-- Assume the patient ID for Alice is 9

-- Insert related records in Services, BillReports, and Consultations tables
INSERT INTO Services (name, description, cost, patient_id, doctor_id) 
VALUES 
  ('X-Ray', 'X-ray for chest', 100.00, 9, 1), 
  ('Blood Test', 'Routine blood test', 50.00, 9, 1);

INSERT INTO BillReports (patient_id, issue_date, amount, payment_status, payment_method) 
VALUES 
  (9, '2024-12-15', 150.00, 'Paid', 'Card');

INSERT INTO Consultations (patient_id, doctor_id, date, notes, prescription) 
VALUES 
  (9, 1, '2024-12-12 10:00:00', 'Patient had chest pain', 'Paracetamol 500mg');
  
SELECT * FROM Patients WHERE id = 9;
SELECT * FROM Services WHERE patient_id = 9;
SELECT * FROM BillReports WHERE patient_id = 9;
SELECT * FROM Consultations WHERE patient_id = 9;

-- We can see after this execution that all associated records are deleted as well
DELETE FROM Patients WHERE id = 9; 


EXPLAIN SELECT * FROM Doctors WHERE email = 'john.doe@example.com';



CALL AddNewPatient(
    'Alexander', 
    'Svilarov', 
    '2004-07-10', 
    'Male', 
    '1234567890', 
    'alex.svl@example.com', 
    '123 Main St', 
    '2024-12-17'
);

SELECT * FROM Patients WHERE email LIKE '%alex%';

CALL GenerateBill(2);
SELECT * FROM BillReports WHERE patient_id = 2;