## Consoles

[iOS](https://appstoreconnect.apple.com/apps/6450636537/appstore/ios/version/inflight)

[Android](https://play.google.com/console/u/0/developers/6507993011983655494/app/4972487045490055287/app-dashboard)

[Firebase](https://console.firebase.google.com/project/date-game-com/overview)

Xcode: `open ios/Runner.xcworkspace`

## Deploy to Web

https://date-game-com.web.app

```
firebase deploy
```

## Deploy to Google Play

```
flutter build appbundle
```

Drop `build/app/outputs/bundle/release/app-release.aab` to 'Internal testing > App bundles.'.

See signing steps here: https://stackoverflow.com/questions/76502832/how-to-sign-flutter-app-bundle-in-order-to-publish-it-to-play-store

## Deploy to iOS

```
flutter build ipa
```

Drop `build/ios/ipa/*.ipa` to Transporter.

## Regenerate icons

```
dart run flutter_launcher_icons
```

Separately update launch image in `ios/Runner/Assets.xcassets/LaunchImage.imageset`.

## Package renaming for android

https://pub.dev/packages/rename

```
run change_app_package_name:main com.dategame
```
