import 'package:anchr_android/mixins/anchr_actions.dart';
import 'package:anchr_android/models/app_state.dart';
import 'package:flutter/material.dart';

class AddLinkPage extends StatefulWidget {
  static const String routeName = '/add';
  static const String title = 'Add new link';
  static final RegExp urlPattern = RegExp('^((http[s]?|ftp):\/)?\/?([^:\/\s]+)((\/\w+)*\/)([\w\-\.]+[^#?\s]+)(.*)?(#[\w\-]+)?');
  final AppState appState;

  AddLinkPage(this.appState, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddLinkPageState(appState);
}

class _AddLinkPageState extends AnchrState<AddLinkPage> with AnchrActions {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _AddLinkPageState(AppState appState) : super(appState);

  @override
  Widget build(BuildContext context) {
    if (appState.collections.isEmpty) {
      loadCollections();
    }

    return Scaffold(
        key: _scaffoldKey,
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
                      validator: (value) => AddLinkPage.urlPattern.hasMatch(value) ? null : 'Not a valid URL.',
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

  @override
  ScaffoldState get scaffold => _scaffoldKey.currentState;
}