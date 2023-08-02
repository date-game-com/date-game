## Consoles

[iOS](https://appstoreconnect.apple.com/apps/6450636537/appstore/ios/version/inflight)

[Android](https://play.google.com/console/u/0/developers/6507993011983655494/app/4972487045490055287/app-dashboard)

[Firebase](https://console.firebase.google.com/project/date-game-com/overview)

Xcode: `open ios/Runner.xcworkspace`

## Deploy to Web

https://date-game-com.web.app

For flutter:
```
git checkout -b stable upstream/stable
```

For date_game

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


## Recreate the project

1. Create project
2. Copy pubspec, gitignore, analysis_options, README
3. Delete platforms except chrome, mac, ios, android
3. Run pub get
4. Copy
  - lib
  - test
  - integration_test
  - assets
3. Update description in web/index
4. Update package name (steps below)
5. Update icon (steps below)
6. Configure Firebase (steps below)
4. Enable outgoing connections (steps below)


### Regenerate icons

```
dart run flutter_launcher_icons
```

Separately update launch image in `ios/Runner/Assets.xcassets/LaunchImage.imageset`:

```
cp -fr assets/icon/icon.png ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png
cp -fr assets/icon/icon.png ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png
cp -fr assets/icon/icon.png ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png

```

### Rename packages

For android:

https://pub.dev/packages/rename

```
dart run change_app_package_name:main com.dategame
```

For iOS and macos replace `com.example.dateGame` with 'com.dategame`

### Configure Firebase

1. Follow https://firebase.google.com/docs/flutter/setup
2. Run `firebase init hosting`

### Enable outgoing connections

For mac/ios:
Lookup `com.apple.security.app-sandbox` and set to false.

### Troubleshooting

Commands that may help:

```
cd macos
sudo gem install cocoapods && pod install
```
