import { describe, it, expect, vi, beforeEach } from 'vitest';
import { fetchBreedData } from '../../src/models/filesBarChart.js';

let container;

beforeEach(() => {
    container = document.createElement('div');
    container.id = 'breedProgressBarsContainer';
    document.body.innerHTML = '';
    document.body.appendChild(container);
    vi.restoreAllMocks();
});

describe('fetchBreedData', () => {
    it('populates data and creates progress bars', async () => {
        const fakeData = [
            { dog_breed: 'Labrador', predictionsCount: 45 },
            { dog_breed: 'Beagle', predictionsCount: 10 },
            { dog_breed: null, predictionsCount: 0 }
        ];

        global.fetch = vi.fn(() =>
            Promise.resolve({
                ok: true,
                json: () => Promise.resolve(fakeData)
            })
        );

        await fetchBreedData();

        expect(container.children.length).toBe(3);

        const firstLabel = container.children[0].querySelector('div');
        expect(firstLabel.textContent).toContain('Labrador');

        const textNode = container.children[0].querySelector('div:last-child div:last-child');
        expect(textNode.textContent).toMatch(/\d+ \/ \d+/);
    });

    it('handles fetch errors gracefully', async () => {
        global.fetch = vi.fn(() =>
            Promise.resolve({ ok: false })
        );

        const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {});

        await fetchBreedData();

        expect(consoleSpy).toHaveBeenCalled();
        expect(container.children.length).toBe(0);
    });
});
