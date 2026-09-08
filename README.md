# ACK Hub mobile

This is a Flutter application targeting Android and iOS from one codebase.

If the platform folders are not already generated, run this once with Flutter installed:

```sh
flutter create --platforms=android,ios .
```

Then fetch packages and run with the API endpoint for your environment:

```sh
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1
```

For an Android device or iOS simulator, replace the emulator address with the API's HTTPS endpoint or your computer's reachable LAN address. Never embed credentials or database URLs in the mobile app.
