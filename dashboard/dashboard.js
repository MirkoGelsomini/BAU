import express from 'express';
import mysql from 'mysql2';
import apiRoutes from './src/routes/api.js';

const app = express();
const PORT = 3001;

const db = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
});

app.set('db', db);

app.use(express.static('html'));
app.use('/css', express.static('css'))
app.use('/models', express.static('models'))
app.use('/api', apiRoutes);

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server in ascolto su http://0.0.0.0:${PORT}`);
});
