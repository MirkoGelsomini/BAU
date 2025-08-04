const express = require('express');
const router = express.Router();
const DogService = require('../models/dogService');

router.get('/dogs-per-user', async (req, res) => {
    try {
        const data = await DogService.getDogsCountPerUser(req.app.get('db'));
        res.json(data);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

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

module.exports = router;
