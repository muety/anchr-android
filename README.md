# Anchr for Android

![](https://anchr.io/i/9w5si.png)

Android client for Anchr.io link collections

## Developer notes
* State handling architecture inspired by [vanilla](https://github.com/brianegan/flutter_architecture_samples/tree/master/example/vanilla).
* Generate launcher icon: `flutter packages pub run flutter_launcher_icons:main`

## To Do
* Change icon and app name
* Improve database helpers (e.g. hide one-to-many relation between collections and links from the outside)
* Automatically refresh token
* Implement `Last-Modified` checking
* Add ability to delete collections