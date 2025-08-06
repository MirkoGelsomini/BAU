import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const labelsPath = path.join(__dirname, '../predicter/labels.json');
const labels = JSON.parse(fs.readFileSync(labelsPath, 'utf-8'));

export function getLabelyKey(label) {
    return Object.keys(labels).find(
        key => labels[key].label_it === label || labels[key].label_en === label
    ) || null;
}
