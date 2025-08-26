
import { initDatabase } from "./databaseCreator.js";

initDatabase()
    .then(() => {
        console.log("✅ Database initialized");
        process.exit(0);
    })
    .catch((err) => {
        console.error("❌ Error initializing database:", err);
        process.exit(1);
    });
