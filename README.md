<p align="center">
  <img src="https://anchr.io/images/logo.png" width="150">
</p>

<h2 align="center">Anchr for Android</h2>


<h3 align="center">
  Android client for Anchr.io link collections, built with Flutter
</h3>

<p align="center">
  <img src="https://badges.fw-web.space/github/license/muety/anchr-android">
  <img src="https://badges.fw-web.space/endpoint?url=https://wakapi.dev/api/compat/shields/v1/n1try/interval:any/project:anchr-android&color=blue&label=time">
  <img src="https://badges.fw-web.space/github/languages/code-size/muety/wakapi">
</p>

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=io.muetsch.anchrandroid&utm_source=github"><img src="https://anchr.io/i/sdr1N.png" width="150"></a>
</p>


## Prerequisites
* A hosted instance of [Anchr](https://github.com/n1try/anchr) and a registered account.
* Java >= 11 (JDK path defined in `android/gradle.properties`)
* Flutter >= 2.5.3
* Dart (tested with 2.14.4)
* Android SDK (tested with v31)
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

### Release
* Have your keystore and password ready, e.g. `~/.android/keystore.jks`
* Make sure you have `android/key.properties`, which looks like so
```
storePassword=shhh
keyPassword=shhh
keyAlias=some_alias_eg_anchr
storeFile=/home/you/.android/keystore.jks
```
* `flutter build apk --release --flavor fmain` to build an APK
* `flutter build appbundle --release --flavor fmain` to build an AppBundle (**recommended**)

#### F-Droid
* [How to add app to F-Droid](https://gitlab.com/fdroid/fdroiddata/blob/master/CONTRIBUTING.md)
* [Build Metadata Reference](https://f-droid.org/docs/Build_Metadata_Reference/)
* [Example `build.gradle` for Flutter build](https://gitlab.com/nikhiljha/lobsters-app/-/blob/4326b69792c8575e5cbea7c0f2f7ff1b2c38d83d/android/app/build.gradle)
* [Example store YML for Flutter build](https://gitlab.com/fdroid/fdroiddata/-/blob/master/metadata/com.nikhiljha.lobstersapp.yml)
* [Fastlane specification](https://gitlab.com/snippets/1895688)

```bash
flutter build apk --flavor fdroid
```

## To Do
There is still plenty of space for improvements. Those include:

* Add ability to sign up
* Add ability to share collections
* Improve database helpers (e.g. hide one-to-many relation between collections and links from the outside)
* Enhance offline mode
  * Show cached content while initial request is pending
* Implement refresh tokens (_requires backend changes_)
* Add tests
* Clean up code

Feel free to contribute!

## License
GNU General Public License v3 (GPL-3) @ [Ferdinand Mütsch](https://muetsch.io)
