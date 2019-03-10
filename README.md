# Anchr for Android

![](https://anchr.io/i/9w5si.png)

Android client for Anchr.io link collections, built with [Flutter](https://flutter.dev).

## Prerequisites
* An existing [Anchr.io](https://anchr.io) account. You can't create one using the app.
* Flutter and Dart to be installed
* Android Studio (or VSCode)
* An Android device or emulator

## How to run?
1. Check out repository
2. Make sure `flutter doctor` has no errors
3. `flutter packages get`
4. `flutter run`

## Developer notes
* State handling architecture inspired by [vanilla](https://github.com/brianegan/flutter_architecture_samples/tree/master/example/vanilla).
* Generate launcher icon: `flutter packages pub run flutter_launcher_icons:main`

## To Do
* Improve database helpers (e.g. hide one-to-many relation between collections and links from the outside)
* Add ability to delete collections
* Implement `Last-Modified` checking (_requires backend changes_)
* Implement refresh tokens (_requires backend changes_)
* Add tests
* Clean up code