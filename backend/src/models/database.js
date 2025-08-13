import mysql from 'mysql2'

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
}).promise()

export default pool;

export async function saveAudioDetails(audioPath, dogBreed) {
    const query = `INSERT INTO audio_predictions (audio_path, dog_breed) VALUES (?, ?)`;

    const [result] = await pool.query(query, [audioPath, dogBreed]);

    return result.insertId;
}


export async function getAllAudioDetails() {
    const query = "SELECT * FROM audio_predictions";

    const [rows] = await pool.query(query);

    if (rows.length > 0) {
        console.log(rows[0]);
    } else {
        console.log("No data found in audio_analysis table.");
    }
}

export async function getAudioDetailById(id) {
    const query = "SELECT * FROM audio_predictions WHERE id = ?"

    const [rows] = await pool.query(query, [id])

    if (rows.length > 0) {
        console.log(rows[0])
    } else {
        console.log(`No audio found with id ${id}`)
    }
}

export async function addAudioPrediction(id, predictions) {

    const queryInsertPrediction = `
    INSERT INTO predictions 
      (top1_label, top1_confidence, top2_label, top2_confidence, top3_label, top3_confidence, created_at)
    VALUES (?, ?, ?, ?, ?, ?, NOW())
  `;

    const topPreds = predictions.slice(0, 3);

    const getLabel = (i) => (topPreds[i] ? topPreds[i].label : null);
    const getConf = (i) => (topPreds[i] ? topPreds[i].confidence : null);

    const params = [
        getLabel(0), getConf(0),
        getLabel(1), getConf(1),
        getLabel(2), getConf(2)
    ];

    const [result] = await pool.query(queryInsertPrediction, params);

    const predictionId = result.insertId;

    const queryUpdateAudio = `
    UPDATE audio_predictions
    SET prediction_id = ?
    WHERE id = ?
  `;

    await pool.query(queryUpdateAudio, [predictionId, id]);

}

export async function saveAudioFeedback(transactionId, isCorrect, correctCategory, comment) {
    const insertQuery = `
    INSERT INTO feedbacks (is_prediction_correct, correct_label, comment, submitted_at)
    VALUES (?, ?, ?, NOW())
  `;

    const [insertResult] = await pool.query(insertQuery, [isCorrect, correctCategory, comment]);

    const feedbackId = insertResult.insertId;

    const updateQuery = `
    UPDATE audio_predictions
    SET feedback_id = ?
    WHERE id = ?
  `;

    await pool.query(updateQuery, [feedbackId, transactionId]);
}

export async function getCorrectCategory(transactionId) {
    const query = `
    SELECT correct_label
    FROM feedbacks
    JOIN audio_predictions ON feedbacks.id = audio_predictions.feedback_id
    WHERE audio_predictions.id = ?
  `;

    const [rows] = await pool.query(query, [transactionId]);

    if (rows.length === 0) return null;

    return rows[0].correct_label;
}


export async function getAudioPath(id) {
    const query = "SELECT audio_path FROM audio_predictions WHERE id = ?";

    const [rows] = await pool.query(query, [id]);

    if (rows.length > 0) {
        return rows[0].audio_path;
    } else {
        throw new Error(`No audio found with id ${id}`);
    }
}

export async function getDogBreed(id) {
    const query = "SELECT dog_breed FROM audio_predictions WHERE id = ?";

    const [rows] = await pool.query(query, [id]);

    if (rows.length > 0) {
        return rows[0].dog_breed;
    } else {
        throw new Error(`No file found with id ${id}`);
    }
}

export async function updateAudioPath(id, newAudioPath) {
    const query = "UPDATE audio_predictions SET audio_path = ? WHERE id = ?";

    const [result] = await pool.query(query, [newAudioPath, id]);

    if (result.affectedRows === 0) {
        throw new Error(`No record updated. ID ${id} not found.`);
    }

}

export async function createUser(username, hashedPassword, firstName, lastName, age, country) {
    const query = `
      INSERT INTO users (username, password, firstName, lastName, age, country)
      VALUES (?, ?, ?, ?, ?, ?)
    `;
    try {
        const [result] = await pool.query(query, [username, hashedPassword, firstName, lastName, age, country]);

        return {
            id: result.insertId,
            username,
            firstName,
            lastName,
            age,
            country
        };
    } catch (err) {
        if (err.code === 'ER_DUP_ENTRY') {
            throw new Error('Username already exists');
        }
        throw err;
    }
}

export async function findUserByUsername(username) {
    const query = 'SELECT * FROM users WHERE username = ?';
    const [rows] = await pool.query(query, [username]);
    return rows;
}

export async function addDog(userId, name, breed, birthDate, gender, weight) {
    const query = `
    INSERT INTO dogs (userId, name, breed, birthDate, gender, weight)
    VALUES (?, ?, ?, ?, ?, ?)
  `;
    try {
        const [result] = await pool.query(query, [userId, name, breed, birthDate, gender, weight]);

        return {
            id: result.insertId,
            userId,
            name,
            breed,
            birthDate,
            gender,
            weight,
        };
    } catch (err) {
        throw err;
    }
}


function formatDateToYYYYMMDD(date) {
    const d = new Date(date);
    const year = d.getFullYear();
    const month = String(d.getMonth() + 1).padStart(2, '0'); // mesi da 0-11
    const day = String(d.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

export async function getDogsByUserId(userId) {
    const query = `
    SELECT id, userId, name, breed, birthDate, gender, weight
    FROM dogs
    WHERE userId = ?
  `;
    try {
        const [rows] = await pool.query(query, [userId]);
        return rows.map(dog => ({
            ...dog,
            birthDate: formatDateToYYYYMMDD(dog.birthDate),
        }));
    } catch (err) {
        throw err;
    }
}


export async function editDog(id, updateFields) {
    const keys = Object.keys(updateFields);
    if (keys.length === 0) {
        throw new Error('No fields to update');
    }

    const setClause = keys.map(key => `${key} = ?`).join(', ');
    const values = keys.map(key => updateFields[key]);

    const query = `
    UPDATE dogs
    SET ${setClause}
    WHERE id = ?
  `;

    try {
        const [result] = await pool.query(query, [...values, id]);
        if (result.affectedRows === 0) {
            throw new Error('Dog not found');
        }

        const [rows] = await pool.query('SELECT * FROM dogs WHERE id = ?', [id]);
        const updatedDog = rows[0];

        updatedDog.birthDate = formatDateToYYYYMMDD(updatedDog.birthDate);

        return updatedDog;
    } catch (err) {
        throw err;
    }
}

export async function deleteDog(userId, dogId) {
    const selectQuery = 'SELECT * FROM dogs WHERE id = ? AND userId = ?';
    const deleteQuery = 'DELETE FROM dogs WHERE id = ? AND userId = ?';

    try {
        const [rows] = await pool.query(selectQuery, [dogId, userId]);
        if (rows.length === 0) {
            return { success: false, message: 'Dog not found or not owned by this user' };
        }

        const [result] = await pool.query(deleteQuery, [dogId, userId]);
        return { success: true, message: 'Dog deleted successfully', affectedRows: result.affectedRows };
    } catch (error) {
        return { success: false, message: 'Server error during deletion' };
    }
}







