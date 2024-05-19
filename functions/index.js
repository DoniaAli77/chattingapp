/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions"); 
var serviceAccount=require('./chattingapp-8fe39-firebase-adminsdk-89cmg-f653184c24.json')
const admin = require("firebase-admin"); 
admin.initializeApp({
    credential:admin.credential.cert(serviceAccount)
}); 
exports.myFunction = functions.firestore.document("chats/{docId}") 
.onCreate((snapshot, context) => { 
return admin.messaging().sendToTopic("classChat", 
{notification: {title: snapshot.data().username, 
body: snapshot.data().text}}); 
}); 