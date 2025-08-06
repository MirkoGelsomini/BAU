const path = require('path');
const express = require('express');
const mysql = require('mysql2');
const dotenv = require('dotenv');
const apiRoutes = require('./routes/api');

dotenv.config({ path: path.resolve(__dirname, '../.env') });

const app = express();
const PORT = 3001;

const db = mysql.createPool({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASSWORD,
    database: process.env.MYSQL_DATABASE,
});

app.set('db', db);

app.use(express.static('html'));
app.use('/css', express.static('css'))
app.use('/models', express.static('models'))
app.use('/api', apiRoutes);

app.listen(PORT, () => {
    console.log(`Server attivo su http://localhost:${PORT}`);
});
