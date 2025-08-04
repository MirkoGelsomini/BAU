import axios from "axios";
import FormData from "form-data";
import fs from "fs";
import path from "path";

const BASE_URL = "http://localhost:3000";

async function registerUser(userData) {
    try {
        const res = await axios.post(`${BASE_URL}/auth/register`, userData);
        if (res.data.success) {
            console.log('Utente registrato:', res.data.user);
            return res.data.user;
        } else {
            console.error('Registrazione fallita:', res.data);
            return null;
        }
    } catch (error) {
        console.error('Errore registrazione utente:', error.response?.data || error.message);
        return null;
    }
}


async function addDog({ userId, name, breed, age, gender, weight }) {
    try {
        const res = await axios.post(`${BASE_URL}/dogs/add`, {
            userId,
            name,
            breed,
            age,
            gender,
            weight,
        });

        const data = res.data;

        if (data.success && data.dog) {
            return { success: true, dog: data.dog };
        } else {
            console.error("Errore logico:", data.message || "Dati mancanti");
            return { success: false, error: data.message || "Errore ignoto" };
        }

    } catch (error) {
        console.error("Errore richiesta HTTP:", {
            status: error.response?.status,
            data: error.response?.data,
            message: error.message,
        });
        return { success: false, error: error.response?.data || error.message };
    }
}


async function uploadAudio({ filePath, dogBreed }) {
    const formData = new FormData();
    formData.append('audio', fs.createReadStream(filePath));
    formData.append('dogBreed', dogBreed);

    const response = await axios.post(`${BASE_URL}/audio/upload`, formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
    });

    return response.data.transactionId;
}


async function sendFeedback({ transactionId, isCorrect, correctCategory, comment }) {
    try {
        const res = await axios.post(`${BASE_URL}/audio/feedback`, {
            transactionId,
            isCorrect,
            correctCategory,
            comment
        });
        console.log('Feedback inviato:', res.data);
        return res.data;
    } catch (error) {
        console.error('Errore invio feedback:', error.response?.data || error.message);
        return null;
    }
}


async function main() {
    const users = [
        { username: "user1@example.com", password: "pass1", firstName: "Mario", lastName: "Rossi", age: "30", country: "Italy" },
        { username: "user2@example.com", password: "pass2", firstName: "Luca", lastName: "Bianchi", age: "25", country: "Italy" },
        { username: "user3@example.com", password: "pass3", firstName: "Anna", lastName: "Verdi", age: "28", country: "Italy" },
        { username: "user4@example.com", password: "pass4", firstName: "Giulia", lastName: "Neri", age: "32", country: "Italy" },
        { username: "user5@example.com", password: "pass5", firstName: "Marco", lastName: "Fontana", age: "27", country: "Italy" },
        { username: "user6@example.com", password: "pass6", firstName: "Elena", lastName: "Marini", age: "35", country: "Italy" },
        { username: "user7@example.com", password: "pass7", firstName: "Stefano", lastName: "Galli", age: "40", country: "Italy" },
        { username: "user8@example.com", password: "pass8", firstName: "Chiara", lastName: "Costa", age: "22", country: "Italy" },
        { username: "user9@example.com", password: "pass9", firstName: "Davide", lastName: "Greco", age: "29", country: "Italy" },
        { username: "user10@example.com", password: "pass10", firstName: "Sara", lastName: "Riva", age: "31", country: "Italy" }
    ];

    const breeds = ["Labrador", "Pomsky", "Golden Retriever", "Beagle", "Bulldog"];

    for (const userData of users) {
        const user = await registerUser(userData);
        if (!user || !user.id) {
            console.warn(`Registrazione utente fallita per ${userData.username}`);
            continue;
        }

        const dogBreed = breeds[Math.floor(Math.random() * breeds.length)];

        const response = await addDog({
            userId: user.id,
            name: `Doggo_${user.username.split("@")[0]}`,
            breed: dogBreed,
            age: Math.floor(Math.random() * 10) + 1,
            gender: Math.random() > 0.5 ? "Male" : "Female",
            weight: Math.floor(Math.random() * 30) + 5,
        });
        if (!response) {
            console.warn(`Aggiunta cane fallita per utente ${user.username}`);
            continue;
        }

        for (let i = 0; i < 5; i++) {
            const audioPath = "../audio.wav";

            const transactionId = await uploadAudio({ filePath: audioPath, dogBreed: response.dog.breed });
            if (!transactionId) {
                console.warn(`Upload audio fallito per cane ${dog.name} (utente ${user.username})`);
                continue;
            }

            await sendFeedback({
                transactionId,
                isCorrect: Math.random() > 0.2,
                correctCategory: 'TEST',
                comment: "Automated feedback",
            });
        }

    }
}


main().catch(console.error);
