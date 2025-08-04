const database = require('./database.js');
const path = require("path");
const fs = require("fs");

exports.saveFileTempOnDisk = (file) => {
    const uploadDir = path.join(__dirname, '..', 'temp')
    if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir);

    const filename = Date.now() + '-' + file.originalname
    const filepath = path.join(uploadDir, filename)

    fs.writeFileSync(filepath, file.buffer)

    return filepath
}

exports.saveFileDefinitive = async (transactionId) => {
    const [audioPath, dogBreed, correctCategory] = await Promise.all([
        database.getAudioPath(transactionId),
        database.getDogBreed(transactionId),
        database.getCorrectCategory(transactionId)
    ]);

    if (!audioPath || !dogBreed || !correctCategory) {
        throw new Error('Informazioni incomplete per la transazione');
    }

    const baseDir = path.join(__dirname, '..', 'sounds', dogBreed, correctCategory);
    if (!fs.existsSync(baseDir)) {
        fs.mkdirSync(baseDir, { recursive: true });
    }

    const filename = path.basename(audioPath);
    const newPath = path.join(baseDir, filename);

    fs.renameSync(audioPath, newPath);

    await database.updateAudioPath(transactionId, newPath);

    console.log(`File spostato in ${newPath} e aggiornato nel DB.`);
}

exports.saveFileInformation = async (audio_path, dogBreed) => {
    return await database.saveAudioDetails(audio_path, dogBreed);
}

exports.saveFilePrediction = async (transactionId, predictions) => {
    return await database.addAudioPrediction(transactionId, predictions);
}

exports.saveFileFeedback = async (transactionId, isCorrect, correctCategory, comment) => {
    await database.saveAudioFeedback(transactionId, isCorrect, correctCategory, comment);
}
