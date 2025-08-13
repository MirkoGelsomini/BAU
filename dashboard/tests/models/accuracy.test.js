import { describe, it, beforeEach, expect, vi } from 'vitest';
import { fetchPredictionAccuracy, fetchBreedAccuracy } from '../../src/models/accuracy.js';

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

    it('updates the DOM values correctly and creates the chart', async () => {
        await fetchPredictionAccuracy();

        expect(totalPredictionsEl.textContent).toBe('10');
        expect(correctPredictionsEl.textContent).toBe('7');
        expect(accuracyPercentageEl.textContent).toBe('70.00%');
        expect(statusAccuracyEl.textContent).toBe('');
    });

    it('handles fetch errors gracefully', async () => {
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

    it('creates a chart for each dog breed', async () => {
        await fetchBreedAccuracy();

        const canvases = containerEl.querySelectorAll('canvas');
        expect(canvases.length).toBe(2);

        const texts = containerEl.querySelectorAll('p');
        expect(texts[0].textContent).toContain('Accuracy:');
    });

    it('handles fetch errors without throwing', async () => {
        global.fetch = vi.fn(() => Promise.reject('Network error'));
        await expect(fetchBreedAccuracy()).resolves.not.toThrow();
    });
});
