const express = require('express');
const mysql = require('mysql2');
const dotenv = require('dotenv');

dotenv.config();

const app = express();

const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USERNAME,
  password: '',
  database: process.env.DB_NAME
});

db.connect((err) => {
  if (err) {
    console.error('Database connection failed:', err.stack);
    return;
  }
  console.log('Connected to the database.');
});

app.use(express.json());

app.get('/patients', (req, res) => {
  const query = 'SELECT patient_id, first_name, last_name, date_of_birth, gender, language, address, phone_number, email FROM patients';
  db.query(query, (err, results) => {
    if (err) {
      res.status(500).json({ message: 'Error retrieving patients' });
      return;
    }
    res.status(200).json(results);
  });
});

app.get('/providers', (req, res) => {
  const query = 'SELECT provider_id, first_name, last_name, provider_specialty, join_date, email, phone_number FROM providers';
  db.query(query, (err, results) => {
    if (err) {
      res.status(500).json({ message: 'Error retrieving providers' });
      return;
    }
    res.status(200).json(results);
  });
});

app.get('/patients/filter', (req, res) => {
  const firstName = req.query.first_name;
  const query = 'SELECT patient_id, first_name, last_name, date_of_birth, gender, language, address, phone_number, email FROM patients WHERE first_name = ?';
  db.query(query, [firstName], (err, results) => {
    if (err) {
      res.status(500).json({ message: 'Error filtering patients' });
      return;
    }
    res.status(200).json(results);
  });
});

app.get('/providers/specialty', (req, res) => {
  const specialty = req.query.specialty;
  const query = 'SELECT provider_id, first_name, last_name, provider_specialty, join_date, email, phone_number FROM providers WHERE provider_specialty = ?';
  db.query(query, [specialty], (err, results) => {
    if (err) {
      res.status(500).json({ message: 'Error retrieving providers by specialty' });
      return;
    }
    res.status(200).json(results);
  });
});

app.get('/visits', (req, res) => {
  const query = 'SELECT v.visit_id, v.patient_id, v.provider_id, v.visit_date, v.reason, v.acuity_level, v.disposition, ' +
                'p.first_name AS patient_first_name, p.last_name AS patient_last_name, ' +
                'pr.first_name AS provider_first_name, pr.last_name AS provider_last_name ' +
                'FROM visits v ' +
                'JOIN patients p ON v.patient_id = p.patient_id ' +
                'JOIN providers pr ON v.provider_id = pr.provider_id';
  db.query(query, (err, results) => {
    if (err) {
      res.status(500).json({ message: 'Error retrieving visits' });
      return;
    }
    res.status(200).json(results);
  });
});

app.get('/admissions', (req, res) => {
  const query = 'SELECT a.admission_id, a.patient_id, a.admission_date, a.primary_diagnosis, a.discharge_disposition, a.service, ' +
                'p.first_name AS patient_first_name, p.last_name AS patient_last_name ' +
                'FROM admissions a ' +
                'JOIN patients p ON a.patient_id = p.patient_id';
  db.query(query, (err, results) => {
    if (err) {
      res.status(500).json({ message: 'Error retrieving admissions' });
      return;
    }
    res.status(200).json(results);
  });
});

app.get('/discharges', (req, res) => {
  const query = 'SELECT d.discharge_id, d.patient_id, d.discharge_date, d.discharge_disposition, ' +
                'p.first_name AS patient_first_name, p.last_name AS patient_last_name ' +
                'FROM discharges d ' +
                'JOIN patients p ON d.patient_id = p.patient_id';
  db.query(query, (err, results) => {
    if (err) {
      res.status(500).json({ message: 'Error retrieving discharges' });
      return;
    }
    res.status(200).json(results);
  });
});

app.get('/appointments', (req, res) => {
  const query = 'SELECT a.appointment_id, a.patient_id, a.provider_id, a.appointment_date, a.reason_for_visit, a.status, ' +
                'p.first_name AS patient_first_name, p.last_name AS patient_last_name, ' +
                'pr.first_name AS provider_first_name, pr.last_name AS provider_last_name ' +
                'FROM appointments a ' +
                'JOIN patients p ON a.patient_id = p.patient_id ' +
                'JOIN providers pr ON a.provider_id = pr.provider_id';
  db.query(query, (err, results) => {
    if (err) {
      res.status(500).json({ message: 'Error retrieving appointments' });
      return;
    }
    res.status(200).json(results);
  });
});

app.get('/medications', (req, res) => {
  const query = 'SELECT m.medication_id, m.patient_id, m.medication_name, m.dose, m.start_date, m.end_date, ' +
                'p.first_name AS patient_first_name, p.last_name AS patient_last_name ' +
                'FROM medications m ' +
                'JOIN patients p ON m.patient_id = p.patient_id';
  db.query(query, (err, results) => {
    if (err) {
      res.status(500).json({ message: 'Error retrieving medications' });
      return;
    }
    res.status(200).json(results);
  });
});

app.get('/billing', (req, res) => {
  const query = 'SELECT b.bill_id, b.patient_id, b.amount_due, b.payment_status, b.bill_date, ' +
                'v.visit_id, v.visit_date, v.reason ' +
                'FROM billing b ' +
                'JOIN visits v ON b.visit_id = v.visit_id';
  db.query(query, (err, results) => {
    if (err) {
      res.status(500).json({ message: 'Error retrieving billing information' });
      return;
    }
    res.status(200).json(results);
  });
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
