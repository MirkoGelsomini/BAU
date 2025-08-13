import express from 'express';
import mysql from 'mysql2';
import apiRoutes from './src/routes/api.js';

import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = 3001;

const db = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
});

app.set('db', db);

app.use('/css', express.static(path.join(__dirname, 'src/css')));
app.use('/models', express.static(path.join(__dirname, 'src/models')));

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'src/html/index.html'));
});

app.use('/api', apiRoutes);

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server in ascolto su http://0.0.0.0:${PORT}`);
});
