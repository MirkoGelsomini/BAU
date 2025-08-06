const express = require('express')
const multer = require('multer')
const upload = multer({ storage: multer.memoryStorage() })

const fileEntryController = require('../controllers/fileController')
const processingController = require('../controllers/processingController')
const feedbackController = require('../controllers/feedbackController')
const authController = require('../controllers/authController')

const router = express.Router()

router.post('/upload', upload.single('audio'), fileEntryController.receiveFile, processingController.processFile);
router.post('/feedback', feedbackController.receiveFeedback, feedbackController.sendFeedbackResponse)
router.post('/register', authController.createAccount);

module.exports = router
