const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.sendNotif = functions.firestore
    .document("billets/{userId}")
    .onCreate((event)=>{
      const newValue=event.data.data();

      const payload={notification: {
        token: newValue.tokenNotification,
        title: "Africars",
        body: "La reservation est effectué par cloud functions",
      }};
      admin.messaging().sendToTopic("Notification", payload)
          .then(function(response) {
            console.log("Notication reussie :", response);
          })
          .catch(function(error) {
            console.log("Notication echec :", error);
          });
    });

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
