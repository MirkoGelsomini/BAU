import * as database from '../models/database.js'

export async function addDog(req, res) {
    const { userId, name, breed, age, gender, weight } = req.body;

    if (!userId || !name) {
        return res.status(400).json({ success: false, message: 'userId e name sono obbligatori' });
    }

    try {
        const dog = await database.addDog(userId, name, breed, age, gender, weight);

        res.status(201).json({
            success: true,
            message: 'Cane aggiunto con successo',
            dog,
        });
    } catch (error) {
        console.error('Errore addDog:', error);
        res.status(500).json({ success: false, message: 'Errore del server' });
    }
}

export async function getDogs(req, res) {
    const userId = req.query.userId;

    if (!userId) {
        return res.status(400).json({ success: false, message: 'userId è obbligatorio' });
    }

    try {
        const dogs = await database.getDogsByUserId(userId);
        res.json({ success: true, dogs });
    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, message: 'Errore del server' });
    }
}

export async function editDog(req, res) {
    const { id, userId, ...updateFields } = req.body;

    if (!id || !userId) {
        return res.status(400).json({ success: false, message: 'userId e id sono obbligatori' });
    }

    try {
        const dogs = await database.getDogsByUserId(userId);
        const dog = dogs.find(d => d.id.toString() === id.toString());


        if (!dog) {
            return res.status(404).json({ success: false, message: 'Cane non trovato per questo utente' });
        }

        const updatedDog = await database.editDog(id, updateFields);
        res.json({ success: true, dog: updatedDog });
    } catch (error) {
        console.error('Errore editDog:', error);
        res.status(500).json({ success: false, message: 'Errore del server' });
    }
}

export async function deleteDog(req, res) {
    const userId = req.query.userId;
    const dogId = req.query.dogId;

    if (!userId || !dogId) {
        return res.status(400).json({ success: false, message: 'userId e dogId sono obbligatori' });
    }

    try {
        const result = await database.deleteDog(userId, dogId);
        if (!result.success) {
            return res.status(404).json(result);
        }
        return res.json(result);
    } catch (err) {
        console.error(err);
        return res.status(500).json({ success: false, message: 'Errore del server' });
    }
}




