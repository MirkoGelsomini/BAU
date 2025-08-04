exports.receiveFile = (req, res, next) => {
    const file = req.file

    if (!file) return res.status(400).json({ error: 'Nessun file ricevuto' })

    req.audioFile = file

    next()
}
