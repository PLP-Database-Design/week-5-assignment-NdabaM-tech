CREATE DATABASE hospital_db;

USE hospital_db;

CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10),
    language VARCHAR(30),
    address VARCHAR(100),
    phone_number VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE providers (
    provider_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    provider_specialty VARCHAR(50),
    join_date DATE,
    email VARCHAR(100),
    phone_number VARCHAR(20)
);

CREATE TABLE visits (
    visit_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    provider_id INT,
    visit_date DATE NOT NULL,
    reason VARCHAR(100),
    acuity_level INT,
    disposition VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (provider_id) REFERENCES providers(provider_id)
);

CREATE TABLE admissions (
    admission_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    admission_date DATE NOT NULL,
    primary_diagnosis VARCHAR(100),
    discharge_disposition VARCHAR(50),
    service VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE discharges (
    discharge_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    discharge_date DATE NOT NULL,
    discharge_disposition VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE ed_visits (
    ed_visit_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    visit_date DATE NOT NULL,
    acuity INT,
    reason VARCHAR(100),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    provider_id INT,
    appointment_date DATE NOT NULL,
    reason_for_visit VARCHAR(100),
    status VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (provider_id) REFERENCES providers(provider_id)
);

CREATE TABLE medications (
    medication_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    medication_name VARCHAR(100),
    dose VARCHAR(50),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE billing (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    amount_due DECIMAL(10, 2),
    payment_status VARCHAR(50),
    bill_date DATE,
    visit_id INT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (visit_id) REFERENCES visits(visit_id)
);

INSERT INTO patients (first_name, last_name, date_of_birth, gender, language, address, phone_number, email)
VALUES
    ('John', 'Doe', '1985-05-15', 'Male', 'English', '123 Elm St', '555-1234', 'john.doe@email.com'),
    ('Mary', 'Smith', '1992-07-22', 'Female', 'Spanish', '456 Oak Ave', '555-5678', 'mary.smith@email.com');

INSERT INTO providers (first_name, last_name, provider_specialty, join_date, email, phone_number)
VALUES
    ('Dr. Alice', 'Johnson', 'Cardiology', '2010-06-01', 'alice.johnson@email.com', '555-2345'),
    ('Dr. Bob', 'White', 'Pediatrics', '2015-09-12', 'bob.white@email.com', '555-6789');

INSERT INTO visits (patient_id, provider_id, visit_date, reason, acuity_level, disposition)
VALUES
    (1, 1, '2023-05-01', 'Check-up', 1, 'Discharged'),
    (2, 2, '2023-06-15', 'Fever', 2, 'Admitted');

INSERT INTO admissions (patient_id, admission_date, primary_diagnosis, discharge_disposition, service)
VALUES
    (1, '2023-05-01', 'Pneumonia', 'Home', 'Cardiology'),
    (2, '2023-06-15', 'Stroke', 'Transferred', 'Neurology');

INSERT INTO discharges (patient_id, discharge_date, discharge_disposition)
VALUES
    (1, '2023-05-10', 'Home'),
    (2, '2023-06-20', 'Transferred');

INSERT INTO ed_visits (patient_id, visit_date, acuity, reason)
VALUES
    (1, '2023-05-01', 3, 'Chest Pain'),
    (2, '2023-06-15', 2, 'Headache');

INSERT INTO appointments (patient_id, provider_id, appointment_date, reason_for_visit, status)
VALUES
    (1, 1, '2023-06-01', 'Heart check-up', 'Scheduled'),
    (2, 2, '2023-07-10', 'Routine check-up', 'Completed');

INSERT INTO medications (patient_id, medication_name, dose, start_date, end_date)
VALUES
    (1, 'Aspirin', '100mg', '2023-05-01', '2023-05-10'),
    (2, 'Ibuprofen', '200mg', '2023-06-15', '2023-06-25');

INSERT INTO billing (patient_id, amount_due, payment_status, bill_date, visit_id)
VALUES
    (1, 250.00, 'Paid', '2023-05-01', 1),
    (2, 500.00, 'Unpaid', '2023-06-15', 2);
