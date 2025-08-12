import * as saveModel from '../models/saveModel.js';

export const saveFileTempOnDisk = (file) => {
    return saveModel.saveFileTempOnDisk(file);
}

export const saveFileDefinitive = async (transactionId) => {
    await saveModel.saveFileDefinitive(transactionId);
}

export const saveFileInformation = async (informations) => {
    const audio_path = informations.file_path;
    const dogBreed = informations.dogBreed;
    return await saveModel.saveFileInformation(audio_path, dogBreed);
}

export const saveFilePrediction = async (transactionId, predictions) => {
    await saveModel.saveFilePrediction(transactionId, predictions);
}

export const saveFileFeedback = async (transactionId, feedback) => {
    const { isCorrect, correctCategory, comment } = feedback;
    await saveModel.saveFileFeedback(transactionId, isCorrect, correctCategory, comment);
}
