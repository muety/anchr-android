import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/pages/collections_page.dart';
import 'package:anchr_android/resources/strings.dart';
import 'package:anchr_android/state/anchr_actions.dart';
import 'package:anchr_android/state/app_state.dart';
import 'package:anchr_android/utils.dart';
import 'package:flutter/material.dart';

class AddLinkPage extends StatefulWidget {
  static const String routeName = '/add';
  final AppState appState;
  final Map<dynamic, dynamic> linkData;

  AddLinkPage(this.appState, {this.linkData, Key key}) : super(key: key);

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
          .then((_) => loadCollection(appState.collections.first.id))
          .then((_) => setState(() => targetCollectionId = appState.activeCollection.id))
          .catchError((e) => showSnackbar(Strings.errorLoadCollections));
      attemptedToLoad = true;
    }

    if (targetCollectionId == null && appState.hasData) {
      targetCollectionId = appState.activeCollection.id;
    }

    appState.currentContext = _scaffoldKey.currentContext;
    appState.currentState = _scaffoldKey.currentState;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(Strings.titleAddNewLinkPage),
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
                            labelText: Strings.labelCollectionInput,
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
                        initialValue: widget.linkData != null && widget.linkData.containsKey(Strings.keySharedLinkUrl)
                            ? widget.linkData[Strings.keySharedLinkUrl]
                            : '',
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.link),
                          hintText: Strings.labelLinkInputHint,
                          labelText: Strings.labelLinkInput,
                        ),
                        onSaved: (url) => targetUrl = url.trim(),
                        validator: (url) => Utils.validateUrl(url.trim()) ? null : Strings.errorInvalidUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                        key: Key('description'),
                        initialValue: widget.linkData != null && widget.linkData.containsKey(Strings.keySharedLinkTitle)
                            ? widget.linkData[Strings.keySharedLinkTitle]
                            : '',
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.text_fields),
                          hintText: Strings.labelLinkDescriptionInputHint,
                          labelText: Strings.labelLinkDescriptionInput,
                        ),
                        onSaved: (description) => targetDescription = description),
                  ),
                  Container(
                    width: screenSize.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: RaisedButton(
                        child: const Text(Strings.labelSaveButton, style: TextStyle(color: Colors.white)),
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
      addLink(targetCollectionId, Link(url: targetUrl, description: targetDescription)).then((_) {
        if (widget.linkData == null || widget.linkData.isEmpty) {
          Navigator.of(context).pop();
        }
        else {
          setLastActiveCollection(targetCollectionId);
          Navigator.of(context).pushReplacementNamed(CollectionsPage.routeName);
        }
      }).catchError((e) => showSnackbar(Strings.errorAddLink));
    }
  }
}
