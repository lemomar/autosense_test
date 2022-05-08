import dotenv from "dotenv";
import { initializeApp } from "firebase-admin/app";
import { Firestore, getFirestore } from "firebase-admin/firestore";
import admin from 'firebase-admin';

dotenv.config();

console.log(process.env.PROJECT_ID);

initializeApp({
    credential: admin.credential.cert({
        projectId: (process.env.PROJECT_ID ?? "").replace(/\\n/g, '\n'),
        clientEmail: (process.env.CLIENT_EMAIL ?? "").replace(/\\n/g, '\n'),
        privateKey: (process.env.PRIVATE_KEY ?? "").replace(/\\n/g, '\n'),
    }),
    databaseURL: "https://console.firebase.google.com/u/0/project/auto-sense-test/database/auto-sense-test-default-rtdb/data/~2F",
    projectId: "auto-sense-test",
});

const db:Firestore = getFirestore();

export default db;
