import 'dart:async';

import 'package:anchr_android/models/args/collection_page_args.dart';
import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/pages/collections_page.dart';
import 'package:anchr_android/resources/strings.dart';
import 'package:anchr_android/state/anchr_actions.dart';
import 'package:anchr_android/state/app_state.dart';
import 'package:anchr_android/utils.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final TextEditingController _linkInputController = new TextEditingController();
  final TextEditingController _descriptionInputController = new TextEditingController();

  _AddLinkPageState(AppState appState) : super(appState);

  bool attemptedToLoad = false;
  String targetCollectionId;
  String _mostRecentUrl = '';
  Timer _linkDebounce;

  @override
  void initState() {
    super.initState();
    _linkInputController.addListener(_onLinkEdit);

    _linkInputController.text = widget.linkData != null && widget.linkData.containsKey(Strings.keySharedLinkUrl)
        ? widget.linkData[Strings.keySharedLinkUrl]
        : '';

    _descriptionInputController.text = widget.linkData != null && widget.linkData.containsKey(Strings.keySharedLinkTitle)
        ? widget.linkData[Strings.keySharedLinkTitle]
        : '';
  }

  @override
  void dispose() {
    _linkInputController.removeListener(_onLinkEdit);
    _linkInputController.dispose();
    _descriptionInputController.dispose();
    super.dispose();
  }

  void _onLinkEdit() {
    if (_linkDebounce?.isActive ?? false) _linkDebounce.cancel();

    final url = _linkInputController.text.trim();
    if (url == _mostRecentUrl || _descriptionInputController.text.isNotEmpty || !Utils.validateUrl(url)) return;

    _linkDebounce = Timer(const Duration(milliseconds: 500), () async {
      if (_descriptionInputController.text.isNotEmpty) return;
      String pageTitle = await getPageTitle(url);
      setState(() => _descriptionInputController.text = pageTitle);
    });

    _mostRecentUrl = url;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    if (appState.collections.isEmpty && !attemptedToLoad) {
      SharedPreferences.getInstance().then((_) {
        loadCollections()
            .then((_) {
              var lastActive = preferences.getString(Strings.keyLastActiveCollectionPref);
              var loadId = appState.collections.any((c) => c.id == lastActive) ? lastActive : appState.collections.first.id;
              loadCollection(loadId);
            })
            .then((_) => setState(() => targetCollectionId = appState.activeCollection.id))
            .catchError((e) { FLog.error(text: Strings.errorLoadCollections, exception: e); showSnackbar(Strings.errorLoadCollections); });
      });
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
                        controller: _linkInputController,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.link),
                          hintText: Strings.labelLinkInputHint,
                          labelText: Strings.labelLinkInput,
                        ),
                        validator: (url) => Utils.validateUrl(url.trim()) ? null : Strings.errorInvalidUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                        key: Key('description'),
                        controller: _descriptionInputController,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.text_fields),
                          hintText: Strings.labelLinkDescriptionInputHint,
                          labelText: Strings.labelLinkDescriptionInput,
                        ),
                    ),
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
      addLink(targetCollectionId, Link(
          url: _linkInputController.text.trim(),
          description: _descriptionInputController.text
      )).then((_) {
        if (widget.linkData == null || widget.linkData.isEmpty) {
          setLastActiveCollection(targetCollectionId);
        }
        Navigator.of(context).pushReplacementNamed(CollectionsPage.routeName, arguments: CollectionPageArgs(targetCollectionId));
      }).catchError((e) { FLog.error(text: Strings.errorAddLink, exception: e); showSnackbar(Strings.errorAddLink); });
    }
  }
}
