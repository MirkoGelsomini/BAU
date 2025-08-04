import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import * as database from '../models/database.js';

const JWT_SECRET = process.env.JWT_SECRET || 'secret_key_da_cambiare';

export async function createAccount(req, res) {
    const { username, password, firstName, lastName, age, country } = req.body;

    if (!username || !password || !firstName || !lastName || !age || !country) {
        return res.status(400).json({ success: false, message: 'Tutti i campi sono obbligatori' });
    }

    try {
        const hashedPassword = await bcrypt.hash(password, 10);
        const newUser = await database.createUser(username, hashedPassword, firstName, lastName, age, country);

        const token = jwt.sign({ username }, 'TUO_SEGRETO', { expiresIn: '1d' });

        res.status(201).json({
            success: true,
            user: newUser,
            token
        });
    } catch (err) {
        if (err.message === 'Username già esistente') {
            return res.status(400).json({ success: false, message: err.message });
        }
        res.status(500).json({ success: false, message: 'Errore del server' });
    }
}

export async function login(req, res) {
    const { username, password } = req.body;

    if (!username || !password) {
        return res.status(400).json({ message: 'Username e password obbligatori' });
    }

    try {
        const users = await database.findUserByUsername(username);

        if (users.length === 0) {
            return res.status(401).json({ message: 'Credenziali non valide' });
        }

        const user = users[0];
        const isMatch = await bcrypt.compare(password, user.password);

        if (!isMatch) {
            return res.status(401).json({ message: 'Credenziali non valide' });
        }

        const token = jwt.sign(
            { userId: user.id, username: user.username },
            JWT_SECRET,
            { expiresIn: '1h' }
        );

        res.json({
            token,
            user: {
                id: user.id,
                username: user.username,
                firstName: user.firstName,
                lastName: user.lastName,
                age: user.age,
                country: user.country,
                email: user.email,
            }
        });

    } catch (err) {
        res.status(500).json({ message: 'Errore del server' });
    }
}
