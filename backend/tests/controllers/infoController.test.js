import { describe, it, expect, vi } from 'vitest';
import { getAllLabels, getAllBreeds } from '../../src/controllers/infoController.js';

describe('Test API handlers', () => {

    it('should return all labels with language filter', async () => {
        const req = { query: { lang: 'label_en' } };
        const jsonMock = vi.fn();
        const res = { json: jsonMock };

        await getAllLabels(req, res);

        expect(jsonMock).toHaveBeenCalled();
        const responseArg = jsonMock.mock.calls[0][0];
        expect(responseArg).toHaveProperty('labels');
    });

    it('should return all labels without lang param', async () => {
        const req = { query: {} };
        const jsonMock = vi.fn();
        const res = { json: jsonMock };

        await getAllLabels(req, res);

        expect(jsonMock).toHaveBeenCalled();
        const responseArg = jsonMock.mock.calls[0][0];

        expect(responseArg).toBeInstanceOf(Object);
    });

    it('should return all breeds', async () => {
        const req = {};
        const jsonMock = vi.fn();
        const statusMock = vi.fn(() => ({ json: jsonMock }));
        const res = { status: statusMock };

        await getAllBreeds(req, res);

        expect(statusMock).toHaveBeenCalledWith(200);
        expect(jsonMock).toHaveBeenCalled();
        const breedNames = jsonMock.mock.calls[0][0];
        expect(Array.isArray(breedNames)).toBe(true);
    });

});
