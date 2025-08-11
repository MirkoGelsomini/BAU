export const getPredictionAccuracy = (db) => {
    return new Promise((resolve, reject) => {
        const sql = `
      SELECT 
        COUNT(*) AS total_predictions,
        SUM(CASE WHEN is_prediction_correct = 1 THEN 1 ELSE 0 END) AS correct_predictions,
        ROUND(SUM(CASE WHEN is_prediction_correct = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS accuracy_percentage
      FROM feedbacks
    `;
        db.query(sql, (err, results) => {
            if (err) return reject(err);
            resolve(results[0]);
        });
    });
};

export const getBreedAccuracy = (db) => {
    return new Promise((resolve, reject) => {
        const sql = `
      SELECT 
        ap.dog_breed,
        COUNT(*) AS total,
        SUM(CASE WHEN f.is_prediction_correct = 1 THEN 1 ELSE 0 END) AS correct,
        ROUND(SUM(CASE WHEN f.is_prediction_correct = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS accuracy
      FROM audio_predictions ap
      JOIN feedbacks f ON ap.feedback_id = f.id
      GROUP BY ap.dog_breed
      ORDER BY accuracy DESC
    `;
        db.query(sql, (err, results) => {
            if (err) return reject(err);
            resolve(results);
        });
    });
};

export const getPredictionsCountPerBreed = (db) => {
    return new Promise((resolve, reject) => {
        const sql = `
      SELECT 
        dog_breed,
        COUNT(*) AS predictionsCount
      FROM audio_predictions
      GROUP BY dog_breed
      ORDER BY predictionsCount DESC
    `;
        db.query(sql, (err, results) => {
            if (err) return reject(err);
            resolve(results);
        });
    });
};
