import express from 'express';

import audioRoutes from './routes/audioRoutes.js';
import authRoutes from './routes/authRoutes.js';
import dogRoutes from './routes/dogRoutes.js';
import infoRoutes from './routes/infoRoutes.js';

const app = express();
const port = 3000;

app.use(express.json());
app.use('/audio', audioRoutes);
app.use('/auth', authRoutes);
app.use('/dogs', dogRoutes);
app.use('/info', infoRoutes);

app.listen(port, '0.0.0.0', () => {
    console.log(`Server in ascolto su http://0.0.0.0:${port}`);
});
