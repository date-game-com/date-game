https://firebase.google.com/docs/functions/get-started

firebase deploy --only firestore:rules

firebase deploy --only functions

Fix lints:

cd functions/
node_modules/eslint/bin/eslint.js . --fix
cd -
