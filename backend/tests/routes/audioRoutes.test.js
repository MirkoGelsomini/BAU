import request from 'supertest';
import { describe, it, expect } from 'vitest';
import app from '../../server.js';

describe('Audio routes basic path tests', () => {
    it('POST /audio/upload should respond', async () => {
        const res = await request(app)
            .post('/audio/upload');

        expect(res.statusCode).not.toBe(404);
    });

    it('POST /audio/feedback should respond', async () => {
        const res = await request(app)
            .post('/audio/feedback');

        expect(res.statusCode).not.toBe(404);
    });
});
