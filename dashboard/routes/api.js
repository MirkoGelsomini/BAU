import express from 'express';
import * as DogService from '../models/dogService.js';

const router = express.Router();

router.get('/prediction-accuracy', async (req, res) => {
    try {
        const data = await DogService.getPredictionAccuracy(req.app.get('db'));
        res.json(data);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/breed-accuracy', async (req, res) => {
    try {
        const data = await DogService.getBreedAccuracy(req.app.get('db'));
        res.json(data);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/predictions-count-per-breed', async (req, res) =>  {
    try {
        const data = await DogService.getPredictionsCountPerBreed(req.app.get('db'));
        res.json(data);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

export default router;
