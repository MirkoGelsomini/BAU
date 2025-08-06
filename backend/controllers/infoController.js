import path from "path";
import fs from "fs/promises";
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
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

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const raw = readFileSync(join(__dirname, '../models/breeds.json'), 'utf-8');
const breeds = JSON.parse(raw);

export async function getAllBreeds(req, res) {
    const breedNames = Object.keys(breeds);
    res.status(200).json(breedNames);
}

export async function getBreedImage(req, res) {
    const { breed } = req.params;

    if (!breed || !breeds[breed]) {
        return res.status(404).json({ error: 'Breed not found' });
    }

    const imageUrl = breeds[breed].image_path;
    res.status(200).json({ imageUrl });
}




