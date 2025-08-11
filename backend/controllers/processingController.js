import * as predictionModel from '../predicter/predictionModel.js';
import * as saveController from '../controllers/saveController.js';
import * as predictionController from '../controllers/predictionController.js';

export const processFile = async (req, res) => {
    const file = req.audioFile;
    const breed = req.body.dogBreed;

    if (!file) return res.status(400).json({ error: 'No file to process' });

    const filePath = saveController.saveFileTempOnDisk(file);

    const predictionResults = await predictionModel.getModelPrediction(filePath, breed);

    const probsArray = await predictionController.getTop3Predictions(predictionResults);

    const transactionId = await saveController.saveFileInformation({
        file_path: filePath,
        dogBreed: breed
    });

    await saveController.saveFilePrediction(transactionId, probsArray);

    const top3Predictions = await predictionController.formatTopPredictions(probsArray);

    res.json({
        message: 'Prediction response',
        transactionId: transactionId,
        prediction: top3Predictions,
    });
};
