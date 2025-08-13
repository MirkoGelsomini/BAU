// tests/models/accuracy.backend.test.js
import { describe, it, expect, vi } from 'vitest';
import {getPredictionAccuracy, getBreedAccuracy, getPredictionsCountPerBreed} from '../../src/models/dogService.js';

// Funzione helper per creare un mock del DB
const createMockDb = (error, results) => ({
    query: vi.fn((sql, cb) => cb(error, results))
});

describe('getPredictionAccuracy', () => {
    it('ritorna i dati corretti quando la query funziona', async () => {
        const fakeResults = [{
            total_predictions: 10,
            correct_predictions: 7,
            accuracy_percentage: 70.00
        }];
        const mockDb = createMockDb(null, fakeResults);

        const result = await getPredictionAccuracy(mockDb);
        expect(result).toEqual(fakeResults[0]);
        expect(mockDb.query).toHaveBeenCalledOnce();
    });

    it('rigetta in caso di errore DB', async () => {
        const mockDb = createMockDb(new Error('DB error'), null);
        await expect(getPredictionAccuracy(mockDb)).rejects.toThrow('DB error');
    });
});

describe('getBreedAccuracy', () => {
    it('ritorna i dati corretti quando la query funziona', async () => {
        const fakeResults = [
            { dog_breed: 'Labrador', total: 5, correct: 4, accuracy: 80.00 },
            { dog_breed: 'Beagle', total: 3, correct: 2, accuracy: 66.67 }
        ];
        const mockDb = createMockDb(null, fakeResults);

        const result = await getBreedAccuracy(mockDb);
        expect(result).toEqual(fakeResults);
        expect(mockDb.query).toHaveBeenCalledOnce();
    });

    it('rigetta in caso di errore DB', async () => {
        const mockDb = createMockDb(new Error('DB error'), null);
        await expect(getBreedAccuracy(mockDb)).rejects.toThrow('DB error');
    });
});

describe('getPredictionsCountPerBreed', () => {
    it('ritorna i dati corretti quando la query funziona', async () => {
        const fakeResults = [
            { dog_breed: 'Labrador', predictionsCount: 5 },
            { dog_breed: 'Beagle', predictionsCount: 3 }
        ];
        const mockDb = createMockDb(null, fakeResults);

        const result = await getPredictionsCountPerBreed(mockDb);
        expect(result).toEqual(fakeResults);
        expect(mockDb.query).toHaveBeenCalledOnce();
    });

    it('rigetta in caso di errore DB', async () => {
        const mockDb = createMockDb(new Error('DB error'), null);
        await expect(getPredictionsCountPerBreed(mockDb)).rejects.toThrow('DB error');
    });
});
