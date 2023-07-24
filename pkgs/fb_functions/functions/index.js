const {logger, pubsub} = require("firebase-functions");
const {onRequest} = require("firebase-functions/v2/https");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, messaging} = require("firebase-admin/firestore");

initializeApp();

exports.sendMessage = onRequest(async (req, res) => {
  // https://firebase.google.com/codelabs/firebase-cloud-functions

  const payload = {
    notification: {
      title: "Hello from Firebase!",
      body: "This is a Firebase Cloud Messaging Topic Message!",
      // icon: "/images/profile_placeholder.png",
      // click_action: `https://${process.env.GCLOUD_PROJECT}.firebaseapp.com`,
    },
  };

  // Get the list of device tokens.
  const allTokens = await getFirestore().collection("FcmTokens").get();
  const tokens = [];
  allTokens.forEach((tokenDoc) => {
    tokens.push(tokenDoc.id);
  });

  if (tokens.length > 0) {
    // Send notifications to all tokens.
    await messaging().sendToDevice(tokens, payload);
    logger.log("Notifications have been sent and tokens cleaned up.");
  }

  res.json({result: `Message sent.`});
});

exports.addmessage = onRequest(async (req, res) => {
  // From .../addMessage?text=uppercasemetoo
  const original = req.query.text;

  const writeResult = await getFirestore()
      .collection("messages")
      .add({original: original});

  res.json({result: `Message with ID: ${writeResult.id} added.`});
});

exports.makeuppercase = onDocumentCreated("/messages/{documentId}", (event) => {
  const original = event.data.data().original;

  logger.log("Uppercasing", event.params.documentId, original);

  const uppercase = original.toUpperCase();

  // You must return a Promise when performing
  // asynchronous tasks inside a function
  // such as writing to Firestore.
  // Setting an 'uppercase' field in Firestore document returns a Promise.
  return event.data.ref.set({uppercase}, {merge: true});
});

exports.process = pubsub.schedule("every 1 minutes").onRun(async () => {
  logger.log("This will be run every minute!");
  await getFirestore()
      .collection("messages")
      .add({hello: "world!"});
});
