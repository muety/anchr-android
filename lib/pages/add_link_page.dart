import 'package:anchr_android/mixins/anchr_actions.dart';
import 'package:anchr_android/models/app_state.dart';
import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/utils.dart';
import 'package:flutter/material.dart';

class AddLinkPage extends StatefulWidget {
  static const String routeName = '/add';
  static const String title = 'Add new link';
  final AppState appState;

  AddLinkPage(this.appState, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddLinkPageState(appState);
}

class _AddLinkPageState extends AnchrState<AddLinkPage> with AnchrActions {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _AddLinkPageState(AppState appState) : super(appState);

  bool attemptedToLoad = false;
  String targetCollectionId;
  String targetUrl;
  String targetDescription;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    if (appState.collections.isEmpty && !attemptedToLoad) {
      loadCollections()
          .then((_) => setState(() => targetCollectionId = appState.activeCollection.id))
          .catchError((e) => showSnackbar('Could not load collections, sorry...'));
      attemptedToLoad = true;
    }

    if (targetCollectionId == null && appState.hasData) {
      targetCollectionId = appState.activeCollection.id;
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(AddLinkPage.title),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DropdownButtonFormField<String>(
                        value: targetCollectionId,
                        decoration: const InputDecoration(
                            icon: const Icon(Icons.list),
                            labelText: 'Collection',
                            contentPadding: const EdgeInsets.only(top: 20)),
                        items: appState.collections
                            .map((c) => DropdownMenuItem<String>(
                                  key: Key(c.id),
                                  child: Text(c.name),
                                  value: c.id,
                                ))
                            .toList(growable: false),
                        onChanged: (id) => setState(() => targetCollectionId = id),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                        key: Key('link'),
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.link),
                          hintText: 'E.g. https://duckduckgo.com',
                          labelText: 'Link',
                        ),
                        onSaved: (url) => targetUrl = url,
                        validator: (url) => Utils.validateUrl(url) ? null : 'Not a valid URL.'),
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
                        onSaved: (description) => targetDescription = description),
                  ),
                  Container(
                    width: screenSize.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: RaisedButton(
                        child: const Text('Save', style: TextStyle(color: Colors.white)),
                        color: Theme.of(context).primaryColor,
                        onPressed: _submit,
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }

  void _submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      addLink(targetCollectionId, Link(url: targetUrl, description: targetDescription))
          .then((_) => Navigator.of(context).pop())
          .catchError((e) => showSnackbar('Could not add link, sorry...'));
    }
  }

  @override
  ScaffoldState get scaffold => _scaffoldKey.currentState;
}
