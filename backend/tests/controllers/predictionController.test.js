import { describe, it, expect, vi, beforeEach } from 'vitest';
import * as fs from 'fs/promises';

import {
    resetLabelsCache,
    loadLabels,
    getTop3Predictions,
    formatTopPredictions
} from '../../src/controllers/predictionController.js';

vi.mock('fs/promises');

describe('Predictions utils', () => {
    const labelsMock = {
        "B-NEU": {
            description: "Neutral bark",
            label_it: "🐶 abbaio neutro",
            label_en: "🐶 neutral bark"
        },
        "B-AGR": {
            description: "Aggressive bark",
            label_it: "😠 abbaio aggressivo",
            label_en: "😠 aggressive bark"
        }
    };

    beforeEach(() => {
        vi.clearAllMocks();
        resetLabelsCache();
    });

    describe('loadLabels', () => {
        it('reads and caches labels.json only once', async () => {
            fs.readFile.mockResolvedValue(JSON.stringify(labelsMock));

            const firstLoad = await loadLabels();
            const secondLoad = await loadLabels();

            expect(fs.readFile).toHaveBeenCalledTimes(1);
            expect(firstLoad).toEqual(labelsMock);
            expect(secondLoad).toEqual(labelsMock);
        });
    });

    describe('getTop3Predictions', () => {
        it('sorts by confidence and limits to 3 results', async () => {
            const predictionResults = {
                probabilities: {
                    'B-NEU': 0.789,
                    'B-AGR': 0.234,
                    'B-OTH': 0.95,
                    'B-FEAR': 0.5
                }
            };

            const top3 = await getTop3Predictions(predictionResults);

            expect(top3).toEqual([
                { label: 'B-OTH', confidence: '0.95' },
                { label: 'B-NEU', confidence: '0.79' },
                { label: 'B-FEAR', confidence: '0.50' }
            ]);
        });
    });

    describe('formatTopPredictions', () => {
        it('adds info from labels.json to the results', async () => {
            fs.readFile.mockResolvedValue(JSON.stringify(labelsMock));

            const probsArray = [
                { label: 'B-NEU', confidence: '0.79' },
                { label: 'B-AGR', confidence: '0.23' }
            ];

            const formatted = await formatTopPredictions(probsArray);

            expect(formatted).toEqual([
                {
                    label: 'B-NEU',
                    confidence: '0.79',
                    description: 'Neutral bark',
                    label_it: '🐶 abbaio neutro',
                    label_en: '🐶 neutral bark'
                },
                {
                    label: 'B-AGR',
                    confidence: '0.23',
                    description: 'Aggressive bark',
                    label_it: '😠 abbaio aggressivo',
                    label_en: '😠 aggressive bark'
                }
            ]);
        });

        it('handles missing labels in labels.json', async () => {
            fs.readFile.mockResolvedValue(JSON.stringify(labelsMock));

            const probsArray = [
                { label: 'B-XYZ', confidence: '0.50' }
            ];

            const formatted = await formatTopPredictions(probsArray);

            expect(formatted).toEqual([
                {
                    label: 'B-XYZ',
                    confidence: '0.50',
                    description: '',
                    label_it: '',
                    label_en: ''
                }
            ]);
        });
    });
});
