import request from 'supertest';
import { describe, it, expect, vi } from 'vitest';
import app from '../../server.js';

vi.mock('../../src/controllers/authController.js', () => ({
    createAccount: (req, res) => res.status(200).json({ message: 'mock createAccount' }),
    login: (req, res) => res.status(200).json({ message: 'mock login' }),
}));

describe('Auth routes basic path tests with mocks', () => {
    it('POST /auth/register should respond', async () => {
        const res = await request(app).post('/auth/register');
        expect(res.statusCode).toBe(200);
        expect(res.body.message).toBe('mock createAccount');
    });

    it('POST /auth/login should respond', async () => {
        const res = await request(app).post('/auth/login');
        expect(res.statusCode).toBe(200);
        expect(res.body.message).toBe('mock login');
    });
});
