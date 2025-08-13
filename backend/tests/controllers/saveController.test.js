import { describe, it, expect, vi, beforeEach } from 'vitest';

vi.mock('../../src/models/saveModel.js', () => ({
    saveFileTempOnDisk: vi.fn(),
    saveFileDefinitive: vi.fn(),
    saveFileInformation: vi.fn(),
    saveFilePrediction: vi.fn(),
    saveFileFeedback: vi.fn()
}));

import * as saveModel from '../../src/models/saveModel.js';
import * as saveController from '../../src/controllers/saveController.js';

describe('saveController', () => {
    beforeEach(() => {
        vi.clearAllMocks();
    });

    it('saveFileTempOnDisk calls saveModel.saveFileTempOnDisk', () => {
        saveModel.saveFileTempOnDisk.mockReturnValue('/tmp/file.wav');

        const result = saveController.saveFileTempOnDisk('file.mp3');

        expect(saveModel.saveFileTempOnDisk).toHaveBeenCalledWith('file.mp3');
        expect(result).toBe('/tmp/file.wav');
    });

    it('saveFileDefinitive calls saveModel.saveFileDefinitive', async () => {
        await saveController.saveFileDefinitive('tx123');
        expect(saveModel.saveFileDefinitive).toHaveBeenCalledWith('tx123');
    });

    it('saveFileInformation passes correct parameters', async () => {
        saveModel.saveFileInformation.mockResolvedValue('new-tx');

        const result = await saveController.saveFileInformation({
            file_path: '/tmp/file.wav',
            dogBreed: 'Chihuahua'
        });

        expect(saveModel.saveFileInformation).toHaveBeenCalledWith('/tmp/file.wav', 'Chihuahua');
        expect(result).toBe('new-tx');
    });

    it('saveFilePrediction calls saveModel.saveFilePrediction', async () => {
        await saveController.saveFilePrediction('tx123', [{ label: 'B-NEU', confidence: '0.95' }]);
        expect(saveModel.saveFilePrediction).toHaveBeenCalledWith('tx123', [{ label: 'B-NEU', confidence: '0.95' }]);
    });

    it('saveFileFeedback passes the correct parameters', async () => {
        const feedback = { isCorrect: true, correctCategory: 'B-NEU', comment: 'Good prediction' };

        await saveController.saveFileFeedback('tx123', feedback);

        expect(saveModel.saveFileFeedback).toHaveBeenCalledWith('tx123', true, 'B-NEU', 'Good prediction');
    });
});
