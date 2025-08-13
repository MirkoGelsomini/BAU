import request from 'supertest';
import { describe, it, expect, vi } from 'vitest';
import app from '../../server.js';

vi.mock('../../src/controllers/infoController.js', () => ({
    getAllLabels: (req, res) => res.status(200).json(['mock label 1', 'mock label 2']),
    getAllBreeds: (req, res) => res.status(200).json(['mock breed 1', 'mock breed 2']),
}));

describe('Info routes basic path tests with mocks', () => {
    it('GET /info/labels should respond', async () => {
        const res = await request(app).get('/info/labels');
        expect(res.statusCode).toBe(200);
        expect(res.body).toEqual(['mock label 1', 'mock label 2']);
    });

    it('GET /info/breeds should respond', async () => {
        const res = await request(app).get('/info/breeds');
        expect(res.statusCode).toBe(200);
        expect(res.body).toEqual(['mock breed 1', 'mock breed 2']);
    });
});
