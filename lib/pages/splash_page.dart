import 'package:anchr_android/resources/assets.dart';
import 'package:anchr_android/resources/strings.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              Assets.iconLauncher,
              width: 200,
            ),
            const Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(Strings.labelLoading),
            )
          ],
        ),
      ),
    );
  }
}
