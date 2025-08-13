// tests/models/accuracy.test.js
import { describe, it, beforeEach, expect, vi } from 'vitest';
import { fetchPredictionAccuracy, fetchBreedAccuracy } from '../../src/models/accuracy.js';

// Mock Chart.js
vi.mock('chart.js', () => {
    return {
        Chart: class {
            constructor() { this.destroy = vi.fn(); }
        }
    };
});

let totalPredictionsEl, correctPredictionsEl, accuracyPercentageEl, statusAccuracyEl, accuracyChartEl;
let containerEl;

describe('fetchPredictionAccuracy', () => {
    beforeEach(() => {
        // Setup DOM
        document.body.innerHTML = `
            <div id="totalPredictions"></div>
            <div id="correctPredictions"></div>
            <div id="accuracyPercentage"></div>
            <div id="status-accuracy"></div>
            <canvas id="accuracyChart"></canvas>
        `;

        totalPredictionsEl = document.getElementById('totalPredictions');
        correctPredictionsEl = document.getElementById('correctPredictions');
        accuracyPercentageEl = document.getElementById('accuracyPercentage');
        statusAccuracyEl = document.getElementById('status-accuracy');
        accuracyChartEl = document.getElementById('accuracyChart');

        // Mock fetch
        global.fetch = vi.fn(() =>
            Promise.resolve({
                ok: true,
                json: () => Promise.resolve({
                    total_predictions: 10,
                    correct_predictions: 7,
                    accuracy_percentage: 70
                }),
            })
        );
    });

    it('aggiorna correttamente i valori e crea il grafico', async () => {
        await fetchPredictionAccuracy();

        expect(totalPredictionsEl.textContent).toBe('10');
        expect(correctPredictionsEl.textContent).toBe('7');
        expect(accuracyPercentageEl.textContent).toBe('70.00%');
        expect(statusAccuracyEl.textContent).toBe('');
    });

    it('gestisce errori di fetch', async () => {
        global.fetch = vi.fn(() => Promise.reject('Fetch failed'));

        await fetchPredictionAccuracy();

        expect(totalPredictionsEl.textContent).toBe('--');
        expect(correctPredictionsEl.textContent).toBe('--');
        expect(accuracyPercentageEl.textContent).toBe('--%');
        expect(statusAccuracyEl.textContent).toBe('Error loading data.');
    });
});

describe('fetchBreedAccuracy', () => {
    beforeEach(() => {
        document.body.innerHTML = `<div id="breedChartsContainer"></div>`;
        containerEl = document.getElementById('breedChartsContainer');

        global.fetch = vi.fn(() =>
            Promise.resolve({
                ok: true,
                json: () => Promise.resolve([
                    { dog_breed: 'Labrador', total: 5, correct: 4 },
                    { dog_breed: 'Beagle', total: 3, correct: 2 }
                ])
            })
        );
    });

    it('crea un grafico per ogni razza', async () => {
        await fetchBreedAccuracy();

        // Controllo che ci siano due canvas (uno per razza)
        const canvases = containerEl.querySelectorAll('canvas');
        expect(canvases.length).toBe(2);

        // Controllo che ci sia il testo dell'accuracy
        const texts = containerEl.querySelectorAll('p');
        expect(texts[0].textContent).toContain('Accuracy:');
    });

    it('gestisce errori di fetch senza lanciare eccezioni', async () => {
        global.fetch = vi.fn(() => Promise.reject('Errore di rete'));
        await expect(fetchBreedAccuracy()).resolves.not.toThrow();
    });
});
