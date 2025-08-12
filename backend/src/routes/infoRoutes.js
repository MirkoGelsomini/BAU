import express from 'express';
import * as infoController from '../controllers/infoController.js';

const router = express.Router();

router.get('/labels', infoController.getAllLabels);
router.get('/breeds', infoController.getAllBreeds);

export default router;
