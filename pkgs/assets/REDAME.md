# Recreate the project

1. Create project
2. Copy pubspec, gitignore, analysis_options, README
3. Delete platforms except chrome, mac, ios, android
3. Run pub get
4. Copy lib, test, integration_test, assets
3. Update description in web/index
4. Update package name
5. Update icone
4. Run for all platforms


## Regenerate icons

```
dart run flutter_launcher_icons
```

Separately update launch image in `ios/Runner/Assets.xcassets/LaunchImage.imageset`.

## Package renaming

https://pub.dev/packages/rename

```
dart run change_app_package_name:main com.dategame
```
