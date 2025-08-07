# 🐾 BAU – Bark Analysis Unleashed

**BAU** is an AI-powered mobile application designed to analyze and interpret dog barks, translating them into meaningful messages understandable by humans. Using **machine learning**, **audio classification**, and **custom datasets**, the app aims to classify barks into predefined categories such as *play*, *alert*, *hunger*, *distress*, or *fear*. The ultimate goal is to enhance human-animal communication through real-time bark recognition and interpretation.

---

## 🔍 Features

- 🎙️ Real-time audio capture and bark detection  
- 🧠 Supervised learning-based audio classification  
- 🐶 Categorization of dog barks into semantic labels (e.g., "Play", "Alarm", "Discomfort")  
- 📱 User-friendly mobile interface for bark translation  
- 📊 Model evaluation using real-world data and user feedback  

---

## 🧠 Technologies

- **Programming**: Python, TensorFlow / PyTorch  
- **Audio Processing**: LibROSA, PyDub  
- **Mobile Development**: Flutter or React Native  
- **Backend (optional)**: Firebase / Node.js  
- **Datasets**: Custom bark dataset + optional pretraining on UrbanSound8K  

---

## 🎯 Objectives

- Strengthen the emotional bond between humans and their dogs  
- Provide a practical tool for understanding dog behavior through vocalization  
- Contribute to the field of animal-centered computing and AI-driven bioacoustics  

---

## ⚙️ Setup Instructions

### 📦 Prerequisites

Before starting, make sure you have the following installed on your system:

#### 🖥️ Development Environment

- [Node.js](https://nodejs.org/) (v18 or higher)
- [Python](https://www.python.org/) (v3.12)
- [Git](https://git-scm.com/)

#### 📚 Python Packages

```bash
pip install tensorflow numpy scikit-learn opensmile
```
📥 Clone the Repository

```bash
git clone https://github.com/yourusername/BAU.git
cd BAU
```

#### 🗄️ Database Initialization Script

This project includes a ready-to-use script that automatically:

- Connects to your MySQL server
- Creates the database (if it doesn’t exist)
- Creates all required tables

#### ▶️ How to run the database setup

1. Make sure you’ve created a valid `.env` file at the root level:

```env
MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASSWORD=yourpassword
MYSQL_DATABASE=databasename
```

1. Run the script from the `backend/utils` folder
```bash
cd backend/utils
node databaseCreator.js
```

1. (OPTIONAL) If you want to add some fake data to your database you can execute this command:
```bash
cd backend/utils
node populateDB.js
```

1. **BACKEND setup**
```bash
cd backend
npm install
```

1. **DASHBOARD setup**
```bash
cd ../dashboard
npm install
```

1. **APPLICATION setup**
```bash
cd bau_application
flutter pub get
```

> 🧪 This project is part of an applied research initiative combining machine learning, animal behavior, and interactive technologies. Contributions are welcome!

