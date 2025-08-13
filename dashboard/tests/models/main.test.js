import { vi } from 'vitest';

vi.mock('../../src/models/accuracy.js', () => ({
    fetchPredictionAccuracy: vi.fn(),
    fetchBreedAccuracy: vi.fn(),
}));

vi.mock('../../src/models/filesBarChart.js', () => ({
    fetchBreedData: vi.fn(),
}));

describe('main.js', () => {
    let fetchPredictionAccuracy, fetchBreedAccuracy, fetchBreedData;

    beforeAll(async () => {
        ({ fetchPredictionAccuracy, fetchBreedAccuracy } = await import('../../src/models/accuracy.js'));
        ({ fetchBreedData } = await import('../../src/models/filesBarChart.js'));
        await import('../../src/models/main.js');
    });

    it('chiama le funzioni subito e ogni minuto', () => {
        expect(fetchPredictionAccuracy).toHaveBeenCalledTimes(1);
        expect(fetchBreedAccuracy).toHaveBeenCalledTimes(1);
        expect(fetchBreedData).toHaveBeenCalledTimes(1);
    });
});
