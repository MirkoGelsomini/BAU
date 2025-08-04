const express = require('express');
const { createAccount, login } = require('../controllers/authController');

const router = express.Router();

router.post('/register', createAccount);
router.post('/login', login);

module.exports = router;
