// src/models/initDatabase.js
import mysql from "mysql2";

const dbName = process.env.DB_NAME;

// Pool principale (senza database selezionato)
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD
}).promise();

async function createDatabaseIfNotExists() {
    const [rows] = await pool.query(
        `SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = ?`,
        [dbName]
    );

    if (!rows.length) {
        await pool.query(`CREATE DATABASE \`${dbName}\`;`);
        console.log(`Database '${dbName}' created successfully.`);
    } else {
        console.log(`Database '${dbName}' already exists.`);
    }
}

async function createUsersTable() {
    await pool.query(`
        CREATE TABLE IF NOT EXISTS users (
            id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(255),
            password VARCHAR(255),
            firstName VARCHAR(255),
            lastName VARCHAR(255),
            age INT,
            country VARCHAR(255),
            createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    `);
}

async function createDogsTable() {
    await pool.query(`
        CREATE TABLE IF NOT EXISTS dogs (
            id INT AUTO_INCREMENT PRIMARY KEY,
            userId INT,
            name VARCHAR(100),
            breed VARCHAR(100),
            birthDate DATE,
            gender ENUM('Male','Female'),
            weight FLOAT,
            createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (userId) REFERENCES users(id)
        );
    `);
}

async function createPredictionsTable() {
    await pool.query(`
        CREATE TABLE IF NOT EXISTS predictions (
            id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            top1_label TEXT,
            top1_confidence FLOAT,
            top2_label TEXT,
            top2_confidence FLOAT,
            top3_label TEXT,
            top3_confidence FLOAT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    `);
}

async function createFeedbacksTable() {
    await pool.query(`
        CREATE TABLE IF NOT EXISTS feedbacks (
            id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            is_prediction_correct TINYINT(1),
            correct_label TEXT,
            comment TEXT,
            submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    `);
}

async function createAudioPredictionsTable() {
    await pool.query(`
        CREATE TABLE IF NOT EXISTS audio_predictions (
            id INT AUTO_INCREMENT PRIMARY KEY,
            audio_path TEXT,
            dog_breed VARCHAR(100),
            prediction_id BIGINT UNSIGNED,
            feedback_id BIGINT UNSIGNED,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (prediction_id) REFERENCES predictions(id),
            FOREIGN KEY (feedback_id) REFERENCES feedbacks(id)
        );
    `);
}

export async function initDatabase() {
    try {
        await createDatabaseIfNotExists();
        await pool.query(`USE \`${dbName}\`;`);

        await createUsersTable();
        await createDogsTable();
        await createPredictionsTable();
        await createFeedbacksTable();
        await createAudioPredictionsTable();

        console.log("All tables are ready.");
    } catch (err) {
        console.error("Error creating tables:", err);
    } finally {
        await pool.end();
    }
}
