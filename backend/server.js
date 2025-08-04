const express = require('express');
const app = express();
const port = 3000;

const audioRoutes = require('./routes/audioRoutes');
const authRoutes = require('./routes/authRoutes')
const dogRoutes = require('./routes/dogRoutes')

app.use(express.json());
app.use('/audio', audioRoutes);
app.use('/auth', authRoutes);
app.use('/dogs', dogRoutes)

app.listen(port, '0.0.0.0', () => {
    console.log(`Server in ascolto su http://0.0.0.0:${port}`);
});
