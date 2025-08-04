import path from 'path';
import fs from 'fs/promises';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);


let labelsData = null;

export async function loadLabels() {
    if (!labelsData) {
        const labelsPath = path.resolve(__dirname, '../predicter/labels.json');
        const fileContent = await fs.readFile(labelsPath, 'utf-8');
        labelsData = JSON.parse(fileContent);
    }
    return labelsData;
}

export async function getTop3Predictions(predictionResults) {
    return Object.entries(predictionResults.probabilities)
        .map(([label, confidence]) => ({
            label,
            confidence: Number(confidence).toFixed(2)
        }))
        .sort((a, b) => b.confidence - a.confidence)
        .slice(0, 3);
}

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

export async function getAllLabels(req, res) {
    try {
        const filePath = path.resolve('./predicter/labels.json');
        const data = await fs.readFile(filePath, 'utf-8');
        const labelsJson = JSON.parse(data);

        const langParam = req.query.lang
        console.log(langParam)
        if (langParam) {
            const labels = Object.entries(labelsJson)
                .reduce((acc, [key, value]) => {
                    if (value[langParam]) {
                        acc[key] = value[langParam];
                    }
                    return acc;
                }, {});


            return res.json({ labels });
        }

        const labelsByLang = {};

        for (const item of Object.values(labelsJson)) {
            for (const key in item) {
                if (key.startsWith('label_')) {
                    if (!labelsByLang[key]) {
                        labelsByLang[key] = [];
                    }
                    labelsByLang[key].push(item[key]);
                }
            }
        }

        res.json(labelsByLang);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Errore nel caricamento delle label' });
    }
}

