import request from 'supertest';
import express from 'express';
import * as DogService from '../../src/models/dogService.js';
import apiRoutes from '../../src/routes/api.js';
import { vi, describe, it, expect, beforeEach } from 'vitest';

vi.mock('../../src/models/dogService.js');

describe('API Routes', () => {
    let app;

    beforeEach(() => {
        app = express();
        app.set('db', {});
        app.use('/api', apiRoutes);
    });

    it('GET /api/prediction-accuracy -> 200 and JSON data', async () => {
        DogService.getPredictionAccuracy.mockResolvedValue({ accuracy_percentage: 95 });

        const res = await request(app).get('/api/prediction-accuracy');

        expect(res.status).toBe(200);
        expect(res.body).toEqual({ accuracy_percentage: 95 });
        expect(DogService.getPredictionAccuracy).toHaveBeenCalledWith({});
    });

    it('GET /api/breed-accuracy -> 200 and JSON data', async () => {
        DogService.getBreedAccuracy.mockResolvedValue([{ breed: 'Labrador', accuracy: 90 }]);

        const res = await request(app).get('/api/breed-accuracy');

        expect(res.status).toBe(200);
        expect(res.body).toEqual([{ breed: 'Labrador', accuracy: 90 }]);
        expect(DogService.getBreedAccuracy).toHaveBeenCalledWith({});
    });

    it('GET /api/predictions-count-per-breed -> 200 and JSON data', async () => {
        DogService.getPredictionsCountPerBreed.mockResolvedValue([
            { dog_breed: 'Beagle', predictionsCount: 12 },
        ]);

        const res = await request(app).get('/api/predictions-count-per-breed');

        expect(res.status).toBe(200);
        expect(res.body).toEqual([{ dog_breed: 'Beagle', predictionsCount: 12 }]);
        expect(DogService.getPredictionsCountPerBreed).toHaveBeenCalledWith({});
    });

    it('Handles errors by returning 500', async () => {
        DogService.getPredictionAccuracy.mockRejectedValue(new Error('DB error'));

        const res = await request(app).get('/api/prediction-accuracy');

        expect(res.status).toBe(500);
        expect(res.body).toEqual({ error: 'DB error' });
    });
});
