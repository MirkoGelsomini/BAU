import { describe, it, expect, vi, beforeEach } from 'vitest';
import { getModelPrediction } from '../../src/predicter/predictionModel.js';
import { spawn } from 'child_process';

vi.mock('child_process', () => ({
    spawn: vi.fn()
}));

describe('getModelPrediction', () => {
    let mockStdout, mockStderr;

    beforeEach(() => {
        vi.clearAllMocks();
        mockStdout = { on: vi.fn() };
        mockStderr = { on: vi.fn() };
    });

    it('risolve con il JSON di output corretto', async () => {
        const fakeProcess = {
            stdout: mockStdout,
            stderr: mockStderr,
            on: vi.fn((event, cb) => {
                if (event === 'close') cb(0);
            })
        };
        spawn.mockReturnValue(fakeProcess);

        // Simula output JSON dal Python
        mockStdout.on.mockImplementation((event, cb) => {
            if (event === 'data') cb(JSON.stringify({ prediction: 'B-NEU', probabilities: { B_NEU: 0.95 } }));
        });

        mockStderr.on.mockImplementation((event, cb) => {});

        const result = await getModelPrediction('file.wav', 'Chihuahua');

        expect(result).toEqual({ prediction: 'B-NEU', probabilities: { B_NEU: 0.95 } });
        expect(spawn).toHaveBeenCalled();
    });

    it('rigetta se il processo Python esce con errore', async () => {
        const fakeProcess = {
            stdout: mockStdout,
            stderr: mockStderr,
            on: vi.fn((event, cb) => {
                if (event === 'close') cb(1);
            })
        };
        spawn.mockReturnValue(fakeProcess);

        mockStderr.on.mockImplementation((event, cb) => {
            if (event === 'data') cb('Errore Python');
        });

        await expect(getModelPrediction('file.wav', 'Chihuahua')).rejects.toThrow('Errore Python');
    });
});
