const express = require('express');
const { addDog, getDogs, editDog, deleteDog } = require('../controllers/dogController');

const router = express.Router();

router.post('/add', addDog);
router.put('/edit', editDog)
router.get('/get', getDogs);
router.delete('/delete', deleteDog);

module.exports = router;
