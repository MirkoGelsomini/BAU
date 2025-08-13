// tests/utils/databaseCreation.test.js
import { describe, it, expect, vi, beforeAll } from "vitest";

// Variabili d'ambiente finte
process.env.DB_NAME = 'testdb';
process.env.DB_HOST = 'localhost';
process.env.DB_USER = 'root';
process.env.DB_PASSWORD = 'root';
process.env.DB_PORT = '3306';

let fakeDB = {};

// Mock mysql2
vi.mock('mysql2', () => {
    const mPool = {
        query: vi.fn(async (sql) => {
            const match = sql.match(/CREATE TABLE IF NOT EXISTS (\w+)/);
            if (match) {
                const tableName = match[1];
                fakeDB[tableName] = sql;
            }
            return [[], []];
        }),
        end: vi.fn(),
    };

    return {
        default: {
            createPool: () => ({
                promise: () => mPool
            })
        }
    };
});

import { initDatabase } from "../../src/utils/databaseCreator.js";

describe("initDatabase table structure", () => {
    beforeAll(async () => {
        fakeDB = {};
        await initDatabase();
    });

    describe("users table", () => {
        it("should have correct columns", () => {
            const sql = fakeDB['users'];
            expect(sql).toMatch(/id INT AUTO_INCREMENT PRIMARY KEY/);
            expect(sql).toMatch(/username VARCHAR\(255\)/);
            expect(sql).toMatch(/password VARCHAR\(255\)/);
            expect(sql).toMatch(/firstName VARCHAR\(255\)/);
            expect(sql).toMatch(/lastName VARCHAR\(255\)/);
            expect(sql).toMatch(/age INT/);
            expect(sql).toMatch(/country VARCHAR\(255\)/);
            expect(sql).toMatch(/createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP/);
        });
    });

    describe("dogs table", () => {
        it("should have correct columns", () => {
            const sql = fakeDB['dogs'];
            expect(sql).toMatch(/id INT AUTO_INCREMENT PRIMARY KEY/);
            expect(sql).toMatch(/userId INT/);
            expect(sql).toMatch(/name VARCHAR\(100\)/);
            expect(sql).toMatch(/breed VARCHAR\(100\)/);
            expect(sql).toMatch(/birthDate DATE/);
            expect(sql).toMatch(/gender ENUM\('Male','Female'\)/);
            expect(sql).toMatch(/weight FLOAT/);
            expect(sql).toMatch(/createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP/);
            expect(sql).toMatch(/FOREIGN KEY \(userId\) REFERENCES users\(id\)/);
        });
    });

    describe("predictions table", () => {
        it("should have correct columns", () => {
            const sql = fakeDB['predictions'];
            expect(sql).toMatch(/id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY/);
            expect(sql).toMatch(/top1_label TEXT/);
            expect(sql).toMatch(/top1_confidence FLOAT/);
            expect(sql).toMatch(/top2_label TEXT/);
            expect(sql).toMatch(/top2_confidence FLOAT/);
            expect(sql).toMatch(/top3_label TEXT/);
            expect(sql).toMatch(/top3_confidence FLOAT/);
            expect(sql).toMatch(/created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP/);
        });
    });

    describe("feedbacks table", () => {
        it("should have correct columns", () => {
            const sql = fakeDB['feedbacks'];
            expect(sql).toMatch(/id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY/);
            expect(sql).toMatch(/is_prediction_correct TINYINT\(1\)/);
            expect(sql).toMatch(/correct_label TEXT/);
            expect(sql).toMatch(/comment TEXT/);
            expect(sql).toMatch(/submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP/);
        });
    });

    describe("audio_predictions table", () => {
        it("should have correct columns", () => {
            const sql = fakeDB['audio_predictions'];
            expect(sql).toMatch(/id INT AUTO_INCREMENT PRIMARY KEY/);
            expect(sql).toMatch(/audio_path TEXT/);
            expect(sql).toMatch(/dog_breed VARCHAR\(100\)/);
            expect(sql).toMatch(/prediction_id BIGINT UNSIGNED/);
            expect(sql).toMatch(/feedback_id BIGINT UNSIGNED/);
            expect(sql).toMatch(/created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP/);
            expect(sql).toMatch(/FOREIGN KEY \(prediction_id\) REFERENCES predictions\(id\)/);
            expect(sql).toMatch(/FOREIGN KEY \(feedback_id\) REFERENCES feedbacks\(id\)/);
        });
    });
});
