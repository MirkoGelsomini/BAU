import path from 'path';
import fs from 'fs/promises';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

let labelsData = null;

export function resetLabelsCache() {
    labelsData = null;
}

// Load labels.json only once and cache it
export async function loadLabels() {
    if (!labelsData) {
        const labelsPath = path.resolve(__dirname, '../predicter/labels.json');
        const fileContent = await fs.readFile(labelsPath, 'utf-8');
        labelsData = JSON.parse(fileContent);
    }
    return labelsData;
}

// Extract top 3 predictions from probabilities with confidence fixed to 2 decimals
export async function getTop3Predictions(predictionResults) {
    return Object.entries(predictionResults.probabilities)
        .map(([label, confidence]) => ({
            label,
            confidence: Number(confidence).toFixed(2)
        }))
        .sort((a, b) => b.confidence - a.confidence)
        .slice(0, 3);
}

// Format top predictions adding label info from labels.json
export async function formatTopPredictions(probsArray) {
    const labels = await loadLabels();
    return probsArray.map(({ label, confidence }) => {
        const labelInfo = labels[label] || {};
        return {
            label,
            confidence,
            description: labelInfo.description || '',
            label_it: labelInfo.label_it || '',
            label_en: labelInfo.label_en || ''
        };
    });
}
