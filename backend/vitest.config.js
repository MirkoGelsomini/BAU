import { defineConfig } from 'vitest/config';

export default defineConfig({
    test: {
        coverage: {
            provider: 'v8',              // forza c8 come provider
            reporter: ['text', 'html'],  // report CLI + HTML
            all: true,
            include: ['src/**/*.js'],        // o '**/src/**/*.js' a seconda della struttura
            exclude: ['node_modules', 'tests'],
        },
        setupFiles: './tests/setup.js'
    },
});
