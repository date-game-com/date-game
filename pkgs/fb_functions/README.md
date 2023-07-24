## Guidance

https://firebase.google.com/docs/functions/get-started


## Deploy rules

// Deploy rules for all configured databases
```
cd ../fb_functions/
firebase deploy --only firestore
```

## Deploy functions

```
cd ../fb_functions/
firebase deploy --only functions
```

## Check logs

Click function menu.

## Troubleshooting

Update soft:
```
npm install firebase-functions@latest firebase-admin@latest --save
sudo npm install -g firebase-tools
```
