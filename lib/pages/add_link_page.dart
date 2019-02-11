import 'package:anchr_android/models/app_state.dart';
import 'package:anchr_android/models/types.dart';
import 'package:flutter/material.dart';

class AddLinkPage extends StatelessWidget {
  static const String routeName = '/add';
  static const String title = 'Add new link';
  static final RegExp urlPattern = RegExp('^((http[s]?|ftp):\/)?\/?([^:\/\s]+)((\/\w+)*\/)([\w\-\.]+[^#?\s]+)(.*)?(#[\w\-]+)?');

  final AppState appState;
  final AnchrActions anchrActions;


  AddLinkPage({Key key, this.appState, this.anchrActions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (appState.collections.isEmpty) {
      anchrActions.loadCollections(context: context);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(AddLinkPage.title),
        ),
        body: Form(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DropdownButtonFormField(
                          key: Key('collection'),
                          decoration: const InputDecoration(
                              icon: const Icon(Icons.list),
                              labelText: 'Collection',
                              contentPadding: const EdgeInsets.only(top: 20)
                          ),
                          items: appState.collections.map((c) =>
                              DropdownMenuItem(
                                key: Key(c.id),
                                child: Text(c.name),
                              )).toList(growable: false))
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      key: Key('link'),
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.link),
                        hintText: 'E.g. https://duckduckgo.com',
                        labelText: 'Link',
                      ),
                      onSaved: (value) => {},
                      validator: (value) => urlPattern.hasMatch(value) ? null : 'Not a valid URL.',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      key: Key('description'),
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.text_fields),
                        hintText: 'Describe the link',
                        labelText: 'Description',
                      ),
                      onSaved: (value) => {}
                    ),
                  ),
                ],
              )
          ),
        )
    );
  }
}