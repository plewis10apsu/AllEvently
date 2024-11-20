import express = require('express');
import { Pool } from 'pg';
import * as dotenv from 'dotenv';
import cors from 'cors';

// Load environment variables from .env file
dotenv.config();

//create express app
const app = express();

app.use(cors({
    origin: 'http://localhost:5173', // Replace with your frontend origin
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
}));

const pool = new Pool({
    connectionString: process.env.POSTGRES_URL,
});

app.get('/api/pet-names', async (req, res) => {
    try {
        // Query the database to fetch pet names
        const result = await pool.query('SELECT name FROM pets');

        // Extract the names from the result
        const names = result.rows.map(row => row.name);

        // Return the names as a JSON response
        res.json({ names });
    } catch (err) {
        console.error('Error fetching pet names', err);
        res.status(500).send('Error fetching pet names');
    }
});


app.get('/', (req, res) => {
    res.send('Welcome to the All Evently API!');
});

app.listen(4000, () => {
    console.log("Backend server running on http://localhost:4000");
});

export default app;
