import {Pool} from 'pg';
import * as dotenv from 'dotenv';
import {IncomingMessage, ServerResponse} from 'http';
//import nodemailer from 'nodemailer';
const nodemailer = require('nodemailer');
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

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'allevently.invitationservice@gmail.com',
        pass: 'csci4805',
    },
});

const handler = async (req: IncomingMessage, res: ServerResponse): Promise<void> => {
    if (req.method === 'POST') {
        try {
            //update to support pdf files soon
            const { guestList, invitationLink } = await parseJsonBody(req);
            if (!guestList) {
                res.statusCode = 400;
                res.end(JSON.stringify({message : 'Error: all fields are required.'}));
                return;
            }
            const mailOptions = {
                from: 'allevently.invitationservice@gmail.com',
                to: guestList.join(','),
                subject: 'Invitation to Event',
                text: `Below is the attached invitation for your event.
                       ${invitationLink}`,
                html: `<p>Please visit the link to respond to your invitation</p><a href ="${invitationLink}">View Invitation</a>`,
            };

            try {
                const info = await transporter.sendMail(mailOptions);
                res.statusCode = 201;
                res.end(JSON.stringify({ message: 'Invitation successfully sent', result: info.response}));
                return;
            } catch (error) {
                res.statusCode = 500;
                res.end(JSON.stringify({ error: 'Failed to send email(s)', details: error}));
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