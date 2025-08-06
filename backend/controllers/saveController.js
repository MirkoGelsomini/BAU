const {getLabelyKey} = require("../utils/labelsUtil");
saveModel = require('../models/saveModel')

exports.saveFileTempOnDisk = (file) => {
    return saveModel.saveFileTempOnDisk(file)
}

exports.saveFileDefinitive = async (transactionId) => {
    await saveModel.saveFileDefinitive(transactionId);
}

exports.saveFileInformation = async (informations) => {
    const audio_path = informations.file_path
    const dogBreed = informations.dogBreed
    return await saveModel.saveFileInformation(audio_path, dogBreed)
}

exports.saveFilePrediction = async (transactionId, predictions) => {
    await saveModel.saveFilePrediction(transactionId, predictions)
}

exports.saveFileFeedback = async (transactionId, feedback) => {
    const { isCorrect, comment } = feedback
    let correctCategory = getLabelyKey(feedback.correctCategory);
    await saveModel.saveFileFeedback(transactionId, isCorrect, correctCategory, comment)
}

