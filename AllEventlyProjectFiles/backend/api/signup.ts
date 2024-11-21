import {Pool} from 'pg';
import * as dotenv from 'dotenv';
import {IncomingMessage, ServerResponse} from 'http';

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
            // Parse the request body
            const {email, password} = await parseJsonBody(req);

            if (!email || !password) {
                res.statusCode = 400;
                res.end(JSON.stringify({message: 'All fields are required.'}));
            }

            // Check if the email already exists in the database
            const emailCheck = await pool.query('SELECT email FROM Accounts WHERE email = $1', [email]);
            if (emailCheck.rows.length > 0) {
                res.statusCode = 400;
                res.end(JSON.stringify({message: 'Email is already registered.'}));
            }

            // Insert the new account
            await pool.query(
                'INSERT INTO Accounts (email, password) VALUES ($1, $2)',
                [email, password]
            );

            res.statusCode = 201;
            res.end(JSON.stringify({message: 'Account created successfully!'}));
        } catch (err) {
            console.error('Error creating account:', err);
            res.statusCode = 500;
            res.end(JSON.stringify({message: 'Internal server error.'}));
        }
    } else {
        // Respond with method not allowed for non-POST requests
        res.statusCode = 405;
        res.end(JSON.stringify({message: 'Method Not Allowed'}));
    }
};

// Export wrapped function with CORS
export default allowCors(handler);
