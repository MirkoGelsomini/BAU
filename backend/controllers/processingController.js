const predictionModel = require('../predicter/predictionModel');
const saveController = require('../controllers/saveController')
const predictionController = require('../controllers/predictionController')

exports.processFile = async (req, res) => {
    const file = req.audioFile
    const breed = req.body.dogBreed

    if (!file) return res.status(400).json({ error: 'Nessun file da processare' })

    const filePath = saveController.saveFileTempOnDisk(file)

    const predictionResults = await predictionModel.getModelPrediction(filePath, breed)

    const probsArray = await predictionController.getTop3Predictions(predictionResults)

    const transactionId = await saveController.saveFileInformation({
        file_path: filePath,
        dogBreed: breed
    })

    await saveController.saveFilePrediction(transactionId, probsArray)

    const top3Predictions = await predictionController.formatTopPredictions(probsArray);


    res.json({
        message: 'PredictionResponse',
        transactionId: transactionId,
        prediction: top3Predictions,
    })
}

