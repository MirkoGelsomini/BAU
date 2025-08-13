import request from 'supertest';
import { describe, it, expect, vi } from 'vitest';
import app from '../../server.js';

// Mock dogController
vi.mock('../../src/controllers/dogController.js', () => ({
    addDog: (req, res) => res.status(200).json({ message: 'mock addDog' }),
    editDog: (req, res) => res.status(200).json({ message: 'mock editDog' }),
    getDogs: (req, res) => res.status(200).json([{ id: 1, name: 'mock dog' }]),
    deleteDog: (req, res) => res.status(200).json({ message: 'mock deleteDog' }),
}));

describe('Dog routes basic path tests with mocks', () => {
    it('POST /dogs/add should respond', async () => {
        const res = await request(app).post('/dogs/add');
        expect(res.statusCode).toBe(200);
        expect(res.body.message).toBe('mock addDog');
    });

    it('PUT /dogs/edit should respond', async () => {
        const res = await request(app).put('/dogs/edit');
        expect(res.statusCode).toBe(200);
        expect(res.body.message).toBe('mock editDog');
    });

    it('GET /dogs/get should respond', async () => {
        const res = await request(app).get('/dogs/get');
        expect(res.statusCode).toBe(200);
        expect(res.body).toEqual([{ id: 1, name: 'mock dog' }]);
    });

    it('DELETE /dogs/delete should respond', async () => {
        const res = await request(app).delete('/dogs/delete');
        expect(res.statusCode).toBe(200);
        expect(res.body.message).toBe('mock deleteDog');
    });
});
