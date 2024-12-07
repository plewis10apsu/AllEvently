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
            if (!<string>body.email || !<string>body.password) {
                res.statusCode = 400;
                res.end(JSON.stringify({message : 'All fields are required.'}));
                return;
            }
            const hashed_password_query = await pool.query('SELECT account_password FROM Accounts WHERE account_email = $1;', [<string>body.email]);
            if (hashed_password_query.rows.length === 0) {
                res.statusCode = 401;
                res.end(JSON.stringify({message: 'Password not Found'}));
                return;
            }

            const hashed_password = hashed_password_query.rows[0].account_password;

            const is_valid = await bcrypt.compare(body.password, hashed_password);

            if (!is_valid) {
                res.statusCode = 401;
                res.end(JSON.stringify({message: 'Incorrect password.'}));
                return;
            }


            const result = await pool.query('SELECT AUTHENTICATE_USER($1, $2);', [<string>body.email, hashed_password]);
            if (result.rows.length === 0) {
                res.statusCode = 401;
                res.end(JSON.stringify({message : 'Invalid Credentials'}));
                return;
            }
            const sessionId: number = result.rows[0]?.authenticate_user || result.rows[0]?.column_name;

            if (sessionId){
                res.statusCode = 201;
                res.end(JSON.stringify({message: 'Login successful', userId: sessionId}));
                return;
            } else {
                res.statusCode = 401;
                res.end(JSON.stringify({message: 'Not Found'}));
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