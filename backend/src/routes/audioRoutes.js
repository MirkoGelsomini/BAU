import express from 'express';
import multer from 'multer';

import * as fileEntryController from '../controllers/fileController.js';
import * as processingController from '../controllers/processingController.js';
import * as feedbackController from '../controllers/feedbackController.js';
import * as authController from '../controllers/authController.js';

const upload = multer({ storage: multer.memoryStorage() });
const router = express.Router();

router.post('/upload', upload.single('audio'), fileEntryController.receiveFile, processingController.processFile);
router.post('/feedback', feedbackController.receiveFeedback, feedbackController.sendFeedbackResponse);
router.post('/register', authController.createAccount);

export default router;
