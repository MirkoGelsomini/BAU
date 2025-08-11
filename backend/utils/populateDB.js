import axios from "axios";
import FormData from "form-data";
import fs from "fs";
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const audioPath = path.join(__dirname, 'audio.wav');
const BASE_URL = process.env.BASE_URL;

async function registerUser(userData) {
    try {
        const res = await axios.post(`${BASE_URL}/auth/register`, userData);
        if (res.data.success) {
            console.log('User registered:', res.data.user);
            return res.data.user;
        } else {
            console.error('Registration failed:', res.data);
            return null;
        }
    } catch (error) {
        console.error('Error registering user:', error.response?.data || error.message);
        return null;
    }
}

async function addDog({ userId, name, breed, birthDate, gender, weight }) {
    try {
        const res = await axios.post(`${BASE_URL}/dogs/add`, {
            userId,
            name,
            breed,
            birthDate,
            gender,
            weight,
        });

        const data = res.data;

        if (data.success && data.dog) {
            return { success: true, dog: data.dog };
        } else {
            console.error("Logical error:", data.message || "Missing data");
            return { success: false, error: data.message || "Unknown error" };
        }

    } catch (error) {
        console.error("HTTP request error:", {
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
        console.log('Feedback sent:', res.data);
        return res.data;
    } catch (error) {
        console.error('Error sending feedback:', error.response?.data || error.message);
        return null;
    }
}

const randomBirthDate = () => {
    const today = new Date();
    const yearsAgo = Math.floor(Math.random() * 10) + 1; // from 1 to 10 years ago
    const daysAgo = Math.floor(Math.random() * 365); // add variability in days
    const birthDate = new Date(today);
    birthDate.setFullYear(today.getFullYear() - yearsAgo);
    birthDate.setDate(birthDate.getDate() - daysAgo);
    return birthDate;
};

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

    const breeds = ["Chihuahua", "FrenchPoodle", "Schnauzer"];

    for (const userData of users) {
        const user = await registerUser(userData);
        if (!user || !user.id) {
            console.warn(`User registration failed for ${userData.username}`);
            continue;
        }

        const dogBreed = breeds[Math.floor(Math.random() * breeds.length)];
        const birthDate = randomBirthDate().toISOString().split("T")[0];

        const response = await addDog({
            userId: user.id,
            name: `Doggo_${user.username.split("@")[0]}`,
            breed: dogBreed,
            birthDate: birthDate,
            gender: Math.random() > 0.5 ? "Male" : "Female",
            weight: Math.floor(Math.random() * 30) + 5,
        });
        if (!response || !response.success || !response.dog) {
            console.warn(`Dog creation failed for user ${user.username}`);
            console.warn("Response:", response);
            continue;
        }

        for (let i = 0; i < 5; i++) {
            const transactionId = await uploadAudio({ filePath: audioPath, dogBreed: response.dog.breed });
            if (!transactionId) {
                console.warn(`Audio upload failed for dog ${response.dog.name} (user ${user.username})`);
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
