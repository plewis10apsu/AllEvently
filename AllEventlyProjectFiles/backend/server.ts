import express from 'express';
import { Pool } from 'pg';
import dotenv from 'dotenv';
import cors from 'cors';

// Load environment variables from .env file
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Enable CORS for all routes
app.use(cors());

// Parse JSON request body
app.use(express.json());

// Create a PostgreSQL connection pool using environment variables
const pool = new Pool({
    user: process.env.POSTGRES_USER,
    host: process.env.POSTGRES_HOST,
    database: process.env.POSTGRES_DB,
    password: process.env.POSTGRES_PASSWORD,
    port: Number(process.env.POSTGRES_PORT),
});

// Sample route to test database connection
app.get('/', async (req, res) => {
    try {
        // Test query to check database connection
        const result = await pool.query('SELECT NOW()');
        res.send(`Database connected! Server time: ${result.rows[0].now}`);
    } catch (err) {
        console.error('Error connecting to database', err);
        res.status(500).send('Error connecting to database');
    }
});

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
