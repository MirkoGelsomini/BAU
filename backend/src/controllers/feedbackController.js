import * as saveController from './saveController.js';

export const receiveFeedback = (req, res, next) => {
    const { transactionId, ...feedbackFields } = req.body;

    if (!transactionId) {
        return res.status(400).json({ error: 'Missing transactionId' });
    }

    req.transactionId = transactionId;
    req.feedback = feedbackFields;

    next();
};

export const sendFeedbackResponse = async (req, res) => {
    const { transactionId, feedback } = req;
    await saveController.saveFileFeedback(transactionId, feedback);
    await saveController.saveFileDefinitive(transactionId);

    res.json({ message: 'Feedback successfully received', feedback, transactionId });
};
