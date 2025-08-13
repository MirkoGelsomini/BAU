// tests/models/breeds-progress.test.js
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { fetchBreedData } from '../../src/models/filesBarChart.js';

// Simuliamo un container DOM
let container;

beforeEach(() => {
    container = document.createElement('div');
    container.id = 'breedProgressBarsContainer';
    document.body.innerHTML = '';
    document.body.appendChild(container);
    vi.restoreAllMocks();
});

describe('fetchBreedData', () => {
    it('popola i dati e crea le progress bar', async () => {
        const fakeData = [
            { dog_breed: 'Labrador', predictionsCount: 45 },
            { dog_breed: 'Beagle', predictionsCount: 10 },
            { dog_breed: null, predictionsCount: 0 } // test nome sconosciuto
        ];

        // Mock fetch
        global.fetch = vi.fn(() =>
            Promise.resolve({
                ok: true,
                json: () => Promise.resolve(fakeData)
            })
        );

        await fetchBreedData();

        // Verifica che il container abbia 3 progress bar
        expect(container.children.length).toBe(3);

        // Primo elemento label
        expect(container.children[0].querySelector('div').textContent)
            .toContain('Labrador');

        // Controllo testo conteggio
        const textNode = container.children[0].querySelector('div:last-child div:last-child');
        expect(textNode.textContent).toMatch(/\d+ \/ \d+/);
    });

    it('gestisce errore di fetch', async () => {
        global.fetch = vi.fn(() =>
            Promise.resolve({ ok: false })
        );

        const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => { });

        await fetchBreedData();

        expect(consoleSpy).toHaveBeenCalled();
        expect(container.children.length).toBe(0);
    });
});
