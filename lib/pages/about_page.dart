import 'package:anchr_android/resources/assets.dart';
import 'package:anchr_android/resources/strings.dart';
import 'package:anchr_android/utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatelessWidget {
  static const String routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(Strings.titleAboutPage),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 16), child: Image.asset(Assets.iconLauncher, width: 48))),
              const Text(Strings.txtAbout),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    child: const Text(Strings.labelViewCodeButton),
                    onPressed: () => Utils.launchURL(Strings.urlGithub),
                  ),
                  ElevatedButton(
                    child: const Text(Strings.labelViewLegal),
                    onPressed: () => Utils.launchURL(Strings.urlLegal),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            return Text(snapshot.data.version + " build " + snapshot.data.buildNumber);
                          }
                        })
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
