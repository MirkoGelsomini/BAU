export const receiveFile = (req, res, next) => {
    const file = req.file;

    if (!file) return res.status(400).json({ error: 'No file received' });

    req.audioFile = file;

    next();
};
