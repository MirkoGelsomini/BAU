// tests/models/saveModel.test.js
import { describe, it, expect, vi, beforeEach } from 'vitest';

// Mock del database
vi.mock('../../src/models/database.js', () => ({
    getAudioPath: vi.fn(),
    getDogBreed: vi.fn(),
    getCorrectCategory: vi.fn(),
    updateAudioPath: vi.fn(),
    saveAudioDetails: vi.fn(),
    addAudioPrediction: vi.fn(),
    saveAudioFeedback: vi.fn()
}));

// Mock di fs e fs/promises
vi.mock('fs', () => {
    const fsMock = {
        existsSync: vi.fn(),
        mkdirSync: vi.fn(),
        writeFileSync: vi.fn()
    };
    return { ...fsMock, default: fsMock };
});

vi.mock('fs/promises', () => {
    const fsPromisesMock = {
        mkdir: vi.fn(),
        copyFile: vi.fn(),
        unlink: vi.fn()
    };
    return { ...fsPromisesMock, default: fsPromisesMock };
});

import * as database from '../../src/models/database.js';
import fs from 'fs';
import fsPromises from 'fs/promises';
import * as saveModel from '../../src/models/saveModel.js';
import path from "path";

describe('saveModel', () => {
    beforeEach(() => {
        vi.clearAllMocks();
    });

    it('saveFileTempOnDisk crea la cartella se non esiste e salva il file', () => {
        fs.existsSync.mockReturnValue(false);
        const fakeFile = { originalname: 'bark.wav', buffer: Buffer.from('sounddata') };

        const filepath = saveModel.saveFileTempOnDisk(fakeFile);

        expect(fs.existsSync).toHaveBeenCalled();
        expect(fs.mkdirSync).toHaveBeenCalled();
        expect(fs.writeFileSync).toHaveBeenCalled();
        expect(filepath).toContain('bark.wav');
    });

    it('saveFileDefinitive copia e rimuove il file originale e aggiorna il DB', async () => {
        database.getAudioPath.mockResolvedValue('/tmp/audio.wav');
        database.getDogBreed.mockResolvedValue('Chihuahua');
        database.getCorrectCategory.mockResolvedValue('B-NEU');

        await saveModel.saveFileDefinitive('tx123');

        expect(fsPromises.mkdir).toHaveBeenCalled();
        expect(fsPromises.copyFile).toHaveBeenCalledWith(
            '/tmp/audio.wav',
            expect.stringContaining(path.join('Chihuahua', 'B-NEU'))
        );
        expect(fsPromises.unlink).toHaveBeenCalledWith('/tmp/audio.wav');
        expect(database.updateAudioPath).toHaveBeenCalled();
    });

    it('saveFileDefinitive lancia errore se mancano dati', async () => {
        database.getAudioPath.mockResolvedValue(null);
        database.getDogBreed.mockResolvedValue('Chihuahua');
        database.getCorrectCategory.mockResolvedValue('B-NEU');

        await expect(saveModel.saveFileDefinitive('tx123'))
            .rejects
            .toThrow('Incomplete information for the transaction');
    });

    it('saveFileInformation chiama database.saveAudioDetails', async () => {
        database.saveAudioDetails.mockResolvedValue('tx456');
        const result = await saveModel.saveFileInformation('/tmp/audio.wav', 'Poodle');
        expect(database.saveAudioDetails).toHaveBeenCalledWith('/tmp/audio.wav', 'Poodle');
        expect(result).toBe('tx456');
    });

    it('saveFilePrediction chiama database.addAudioPrediction', async () => {
        await saveModel.saveFilePrediction('tx789', [{ label: 'B-NEU', confidence: '0.95' }]);
        expect(database.addAudioPrediction).toHaveBeenCalledWith(
            'tx789',
            [{ label: 'B-NEU', confidence: '0.95' }]
        );
    });

    it('saveFileFeedback chiama database.saveAudioFeedback', async () => {
        await saveModel.saveFileFeedback('tx000', true, 'B-NEU', 'Comment');
        expect(database.saveAudioFeedback).toHaveBeenCalledWith('tx000', true, 'B-NEU', 'Comment');
    });
});
