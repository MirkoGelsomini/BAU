// tests/processFile.test.js
import { describe, it, expect, vi, beforeEach } from 'vitest';

vi.mock('../../src/predicter/predictionModel.js', () => ({
    getModelPrediction: vi.fn()
}));

vi.mock('../../src/controllers/saveController.js', () => ({
    saveFileTempOnDisk: vi.fn(),
    saveFileInformation: vi.fn(),
    saveFilePrediction: vi.fn()
}));

vi.mock('../../src/controllers/predictionController.js', () => ({
    getTop3Predictions: vi.fn(),
    formatTopPredictions: vi.fn()
}));

import * as predictionModel from '../../src/predicter/predictionModel.js';
import * as saveController from '../../src/controllers/saveController.js';
import * as predictionController from '../../src/controllers/predictionController.js';
import { processFile } from '../../src/controllers/processingController.js';

describe('processFile', () => {
    let req, res;

    beforeEach(() => {
        req = {
            audioFile: { name: 'dogbark.wav' },
            body: { dogBreed: 'Chihuahua' }
        };
        res = {
            status: vi.fn().mockReturnThis(),
            json: vi.fn()
        };

        vi.clearAllMocks();
    });

    it('ritorna errore 400 se manca il file', async () => {
        req.audioFile = null;

        await processFile(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({ error: 'No file to process' });
    });

    it('elabora il file e ritorna le previsioni', async () => {
        // Mock comportamento funzioni esterne
        saveController.saveFileTempOnDisk.mockReturnValue('/tmp/file.wav');
        predictionModel.getModelPrediction.mockResolvedValue({ probabilities: {} });
        predictionController.getTop3Predictions.mockResolvedValue([
            { label: 'B-NEU', confidence: '0.95' }
        ]);
        saveController.saveFileInformation.mockResolvedValue('tx123');
        saveController.saveFilePrediction.mockResolvedValue();
        predictionController.formatTopPredictions.mockResolvedValue([
            { label: 'B-NEU', confidence: '0.95', description: 'Neutral bark' }
        ]);

        await processFile(req, res);

        expect(saveController.saveFileTempOnDisk).toHaveBeenCalledWith(req.audioFile);
        expect(predictionModel.getModelPrediction).toHaveBeenCalledWith('/tmp/file.wav', 'Chihuahua');
        expect(predictionController.getTop3Predictions).toHaveBeenCalled();
        expect(saveController.saveFileInformation).toHaveBeenCalledWith({
            file_path: '/tmp/file.wav',
            dogBreed: 'Chihuahua'
        });
        expect(saveController.saveFilePrediction).toHaveBeenCalledWith('tx123', [
            { label: 'B-NEU', confidence: '0.95' }
        ]);
        expect(predictionController.formatTopPredictions).toHaveBeenCalledWith([
            { label: 'B-NEU', confidence: '0.95' }
        ]);
        expect(res.json).toHaveBeenCalledWith({
            message: 'Prediction response',
            transactionId: 'tx123',
            prediction: [
                { label: 'B-NEU', confidence: '0.95', description: 'Neutral bark' }
            ]
        });
    });
});
