## Deploy to Web

https://date-game-com.web.app

```
firebase deploy
```

## Deploy to Google Play

```
flutter build appbundle
```

See result at `build/app/outputs/bundle/release/app-release.aab`.

See signing steps here: https://stackoverflow.com/questions/76502832/how-to-sign-flutter-app-bundle-in-order-to-publish-it-to-play-store

## Deploy to iOS

```
flutter build ipa
```

Drop `build/ios/ipa/*.ipa` to Transporter.


## Regenerate Icons

```
dart run flutter_launcher_icons
```

Separately update launch image in `ios/Runner/Assets.xcassets/LaunchImage.imageset`.
