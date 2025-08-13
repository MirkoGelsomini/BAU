import * as database from '../models/database.js'

export async function addDog(req, res) {
    const { userId, name, breed, birthDate, gender, weight } = req.body;

    if (!userId || !name) {
        return res.status(400).json({ success: false, message: 'userId and name are required' });
    }

    try {
        const dog = await database.addDog(userId, name, breed, birthDate.split('T')[0], gender, weight);

        res.status(201).json({
            success: true,
            message: 'Dog added successfully',
            dog,
        });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

export async function getDogs(req, res) {
    const userId = req.query.userId;

    if (!userId) {
        return res.status(400).json({ success: false, message: 'userId is required' });
    }

    try {
        const dogs = await database.getDogsByUserId(userId);
        res.json({ success: true, dogs });
    } catch (err) {
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

export async function editDog(req, res) {
    const { id, userId, ...updateFields } = req.body;

    if (!id || !userId) {
        return res.status(400).json({ success: false, message: 'userId and id are required' });
    }

    if (updateFields.birthDate) {
        updateFields.birthDate = updateFields.birthDate.split('T')[0];
    }

    try {
        const dogs = await database.getDogsByUserId(userId);
        const dog = dogs.find(d => d.id.toString() === id.toString());

        if (!dog) {
            return res.status(404).json({ success: false, message: 'Dog not found for this user' });
        }

        const updatedDog = await database.editDog(id, updateFields);

        res.json({ success: true, dog: updatedDog });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

export async function deleteDog(req, res) {
    const userId = req.query.userId;
    const dogId = req.query.dogId;

    if (!userId || !dogId) {
        return res.status(400).json({ success: false, message: 'userId and dogId are required' });
    }

    try {
        const result = await database.deleteDog(userId, dogId);
        if (!result.success) {
            return res.status(404).json(result);
        }
        return res.json(result);
    } catch (err) {
        return res.status(500).json({ success: false, message: 'Server error' });
    }
}
