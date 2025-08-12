import express from 'express';
import { addDog, getDogs, editDog, deleteDog } from '../controllers/dogController.js';

const router = express.Router();

router.post('/add', addDog);
router.put('/edit', editDog)
router.get('/get', getDogs);
router.delete('/delete', deleteDog);

export default router;
