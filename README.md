# Anchr for Android
[![Say thanks](https://img.shields.io/badge/SayThanks.io-%E2%98%BC-1EAEDB.svg)](https://saythanks.io/to/n1try)

![](https://anchr.io/i/ccrHg.png)

Android client for Anchr.io link collections, built with **[Flutter](https://flutter.dev)**. This project is in an **early development phase** and therefore not yet feature-complete or free of bugs.

[![Buy me a coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://buymeacoff.ee/n1try)

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
There is still plenty of space for improvements. Those include:

* Add ability to sign up
* Add ability to delete collections
* Add ability to share collections
* Improve database helpers (e.g. hide one-to-many relation between collections and links from the outside)
* Enhance offline mode
  * Show cached content while initial request is pending
* Implement refresh tokens (_requires backend changes_)
* Add tests
* Clean up code

Feel free to contribute!

## License
GNU General Public License v3 (GPL-3) @ [Ferdinand Mütsch](https://ferdinand-muetsch.de)