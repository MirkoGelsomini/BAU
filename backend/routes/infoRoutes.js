const express = require('express');
const infoController = require("../controllers/infoController");

const router = express.Router();

router.get('/labels', infoController.getAllLabels)
router.get('/breeds', infoController.getAllBreeds)
router.get('/imageUrl/:breed', infoController.getBreedImage)
module.exports = router;
