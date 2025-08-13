// tests/setup.js
import { vi } from 'vitest';

global.Chart = vi.fn().mockImplementation(() => {
    return {
        destroy: vi.fn(),
        update: vi.fn(),
    };
});

beforeAll(() => {
    vi.spyOn(console, 'error').mockImplementation(() => {});
    vi.spyOn(console, 'warn').mockImplementation(() => {});
    vi.spyOn(console, 'log').mockImplementation(() => {});
});
