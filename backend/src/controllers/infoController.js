import path from "path";
import fs from "fs/promises";
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

export async function getAllLabels(req, res) {
    try {
        const labelsPath = path.join(__dirname, '../predicter/labels.json');
        const data = await fs.readFile(labelsPath, 'utf-8');
        const labelsJson = JSON.parse(data);

        const langParam = req.query.lang; // es. "label_en"

        if (langParam) {
            const labels = Object.entries(labelsJson).reduce((acc, [key, value]) => {
                if (value[langParam]) {
                    acc[key] = {
                        label: value[langParam],
                        status: value.status
                    };
                }
                return acc;
            }, {});
            return res.json({ labels });
        }

        // Se non passi ?lang, restituisco tutte le lingue con status
        const labelsByLang = {};
        for (const [code, item] of Object.entries(labelsJson)) {
            for (const key in item) {
                if (key.startsWith('label_')) {
                    if (!labelsByLang[key]) {
                        labelsByLang[key] = [];
                    }
                    labelsByLang[key].push({
                        code,
                        label: item[key],
                        status: item.status
                    });
                }
            }
        }

        res.json(labelsByLang);
    } catch (error) {
        console.error(error)
        res.status(500).json({ error: 'Error loading labels' });
    }
}

export async function getAllBreeds(req, res) {
    try {
        const breedsPath = path.join(__dirname, '../models/breeds.json');
        const raw = readFileSync(breedsPath, 'utf-8');
        const breeds = JSON.parse(raw);
        const breedNames = Object.values(breeds);
        res.status(200).json(breedNames);
    } catch (error) {
        res.status(500).json({ error: 'Error loading breeds' });
    }
}
