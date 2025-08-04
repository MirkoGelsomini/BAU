const fs = require('fs');
const path = require('path');
const saveController = require('../controllers/saveController')

exports.receiveFeedback = (req, res, next) => {
    const { transactionId, ...feedbackFields } = req.body

    if (!transactionId) {
        return res.status(400).json({ error: 'transactionId mancante' })
    }

    req.transactionId = transactionId
    req.feedback = feedbackFields

    next()
};


exports.sendFeedbackResponse = async (req, res) => {
    const { transactionId, feedback } = req

    await saveController.saveFileFeedback(transactionId, feedback)
    await saveController.saveFileDefinitive(transactionId)
    
    res.json({ message: 'Feedback ricevuto con successo', feedback, transactionId })
}
