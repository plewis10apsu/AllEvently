import express from 'express';
import { Pool } from 'pg';
import dotenv from 'dotenv';

// Load environment variables from .env file
dotenv.config();

const app = express();

const pool = new Pool({
    connectionString: process.env.POSTGRES_URL,
    ssl: {
        rejectUnauthorized: false, // Necessary for cloud-hosted databases if SSL is enabled
    },
});

// Sample route to test database connection
app.get('/api', async (req, res) => {
    try {
        // Test query to check database connection
        const result = await pool.query('SELECT NOW()');
        res.send(`Database connected! Server time: ${result.rows[0].now}`);
    } catch (err) {
        console.error('Error connecting to database', err);
        res.status(500).send('Error connecting to database');
    }
});

export default app;
