import {Pool} from 'pg';
import * as dotenv from 'dotenv';
import {IncomingMessage, ServerResponse} from 'http';
const bcrypt = require('bcrypt');

dotenv.config();

const pool = new Pool({
    connectionString: process.env.POSTGRES_URL,
});

// Helper function to parse JSON body
const parseJsonBody = (req: IncomingMessage) =>
    new Promise<any>((resolve, reject) => {
        let body = '';
        req.on('data', chunk => {
            body += chunk;
        });
        req.on('end', () => {
            try {
                resolve(JSON.parse(body)); // Parse body as JSON
            } catch (err) {
                reject(err); // Reject if there is an error parsing JSON
            }
        });
    });

// Vercel's CORS wrapper
const allowCors = (fn: (req: IncomingMessage, res: ServerResponse) => Promise<void>) =>
    async (req: IncomingMessage, res: ServerResponse): Promise<void> => {
        res.setHeader('Access-Control-Allow-Credentials', 'true');
        res.setHeader('Access-Control-Allow-Origin', '*'); // Or use a specific frontend URL
        res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT');
        res.setHeader(
            'Access-Control-Allow-Headers',
            'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version'
        );

        if (req.method === 'OPTIONS') {
            res.statusCode = 200;
            res.end();
            return;
        }

        return await fn(req, res);
    };

const handler = async (req: IncomingMessage, res: ServerResponse): Promise<void> => {
    if (req.method === 'POST') {
        try {
            const body = await parseJsonBody(req);
            if (!body.email) {
                res.statusCode = 400;
                res.end(JSON.stringify({ message: 'User not in database.'}));
                return;
            }
            try {
                const result = await pool.query('SELECT event_id FROM Events WHERE event_host = $1;', [body.email]);
                if (result.rows.length == 0) {
                    res.statusCode = 404;
                    res.end(JSON.stringify({ message: 'No events hosted by provided user'}));
                    return;
                }
                const eventId = result.rows[0].event_id;
                res.statusCode = 200;
                res.end(JSON.stringify({ message: 'Event ID successfully found', eventId: eventId}));
                return;
            } catch (error) {
                res.statusCode = 500;
                res.end(JSON.stringify({ message: 'Internal Server Error' }));
                return;
            }
        } catch (error) {
            console.error(error);
            res.statusCode = 500;
            res.end(JSON.stringify({message : 'Error logging in'}));
            return;
        }
    } else {
        res.statusCode = 405;
        res.end(JSON.stringify({message: 'Method Not Allowed'}));
        console.log("Method: "+req.method);
        return;
    }
};

export default allowCors(handler);