import * as database from './database.js';
import path from 'path';
import fs from 'fs';
import fsPromises from 'fs/promises';
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const saveFileTempOnDisk = (file) => {
    const uploadDir = path.join(__dirname, '..', 'temp');
    if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir);

    const filename = Date.now() + '-' + file.originalname;
    const filepath = path.join(uploadDir, filename);

    fs.writeFileSync(filepath, file.buffer);

    return filepath;
}

export const saveFileDefinitive = async (transactionId) => {
    const [audioPath, dogBreed, correctCategory] = await Promise.all([
        database.getAudioPath(transactionId),
        database.getDogBreed(transactionId),
        database.getCorrectCategory(transactionId)
    ]);

    if (!audioPath || !dogBreed || !correctCategory) {
        throw new Error('Incomplete information for the transaction');
    }

    const baseDir = path.join(__dirname, '..', 'sounds', dogBreed, correctCategory);

    // Use fsPromises and recursive:true for safety
    await fsPromises.mkdir(baseDir, { recursive: true });

    const filename = path.basename(audioPath);
    const newPath = path.join(baseDir, filename);

    await fsPromises.copyFile(audioPath, newPath);
    await fsPromises.unlink(audioPath);

    await database.updateAudioPath(transactionId, newPath);

    console.log(`File moved to ${newPath} and updated in DB.`);
}

export const saveFileInformation = async (audio_path, dogBreed) => {
    return await database.saveAudioDetails(audio_path, dogBreed);
}

export const saveFilePrediction = async (transactionId, predictions) => {
    return await database.addAudioPrediction(transactionId, predictions);
}

export const saveFileFeedback = async (transactionId, isCorrect, correctCategory, comment) => {
    await database.saveAudioFeedback(transactionId, isCorrect, correctCategory, comment);
}
