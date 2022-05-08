import express from 'express';
import { initializeApp } from 'firebase-admin/app';
import admin from 'firebase-admin';

var serviceAccount:string = process.env.GOOGLE_APPLICATION_CREDENTIALS || "";

initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: 'https://<DATABASE_NAME>.firebaseio.com',
    projectId: "auto-sense-test",
});

const app = express();

app.get('/', (req, res) => {
    res.send('Well done!');
})

app.listen(3000, () => {
    console.log('The application is listening on port 3000!');
})