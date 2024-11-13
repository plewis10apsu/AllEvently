import express from 'express';
import { Pool } from 'pg';
import dotenv from 'dotenv';

// Load environment variables from .env file
dotenv.config();

//create express app
const app = express();

const pool = new Pool({
    connectionString: process.env.POSTGRES_URL,
});

// Sample route to test database connection
app.get('/api', async (req, res) => {
    try {
        const result = await pool.query('SELECT NOW()');
        res.send(`Database connected! Server time: ${result.rows[0].now}`);
    } catch (err) {
        console.error('Error connecting to database', err);
        res.status(500).send('Error connecting to database');
    }
});

app.get('/', (req, res) => {
    res.send('Welcome to the All Evently API!');
});

app.listen(4000, () => {
    console.log("Backend server running on http://localhost:4000");
});

export default app;
