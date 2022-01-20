import 'dart:async';

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
  final TextEditingController _linkInputController = TextEditingController();
  final TextEditingController _descriptionInputController = TextEditingController();

  _AddLinkPageState(AppState appState) : super(appState);

  bool _attemptedToLoad = false;
  String _targetCollectionId;
  String _mostRecentUrl = '';
  Timer _linkDebounce;

  @override
  void initState() {
    super.initState();

    _descriptionInputController.text = widget.linkData != null && widget.linkData.containsKey(Strings.keySharedLinkTitle) ? widget.linkData[Strings.keySharedLinkTitle] : '';
    _linkInputController.addListener(_onLinkEdit);
    _linkInputController.text = widget.linkData != null && widget.linkData.containsKey(Strings.keySharedLinkUrl) ? widget.linkData[Strings.keySharedLinkUrl] : '';
  }

  @override
  void dispose() {
    _linkInputController.removeListener(_onLinkEdit);
    _linkInputController.dispose();
    _descriptionInputController.dispose();
    super.dispose();
  }

  void _onLinkEdit() {
      final url = _linkInputController.text.trim();
      if (url == _mostRecentUrl || _descriptionInputController.text.isNotEmpty || !Utils.validateUrl(url)) return;

      if (_linkDebounce?.isActive ?? false) _linkDebounce.cancel();

      _linkDebounce = Timer(const Duration(milliseconds: 1000), () async {
        if (_descriptionInputController.text.isNotEmpty) return;
        setState(() => _descriptionInputController.text = Strings.labelLoading);
        String pageTitle = await getPageTitle(url);
        setState(() => _descriptionInputController.text = pageTitle ?? '');
      });

      _mostRecentUrl = url;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    if (appState.collections.isEmpty && !_attemptedToLoad) {
      SharedPreferences.getInstance()
          .then((_) => loadCollections())
          .then((_) {
            var lastActive = preferences.getString(Strings.keyLastActiveCollectionPref);
            var loadId = appState.collections.any((c) => c.id == lastActive) ? lastActive : appState.collections.first.id;
            return loadCollection(loadId);
          })
          .then((_) => setState(() => _targetCollectionId = appState.activeCollection.id))
          .catchError((e) {
            FLog.error(text: Strings.errorLoadCollections, exception: e);
            showSnackbar(Strings.errorLoadCollections);
          });
      _attemptedToLoad = true;
    }

    if (_targetCollectionId == null && appState.hasData) {
      _targetCollectionId = appState.activeCollection.id;
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
                        value: _targetCollectionId,
                        decoration: const InputDecoration(icon: Icon(Icons.list), labelText: Strings.labelCollectionInput, contentPadding: EdgeInsets.only(top: 20)),
                        items: appState.collections
                            .map((c) => DropdownMenuItem<String>(
                                  key: Key(c.id),
                                  child: Text(c.name),
                                  value: c.id,
                                ))
                            .toList(growable: false),
                        onChanged: (id) => setState(() => _targetCollectionId = id),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                        key: Key('link'),
                        controller: _linkInputController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.link),
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
                        icon: Icon(Icons.text_fields),
                        hintText: Strings.labelLinkDescriptionInputHint,
                        labelText: Strings.labelLinkDescriptionInput,
                      ),
                    ),
                  ),
                  Container(
                    width: screenSize.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ElevatedButton(
                        child: const Text(Strings.labelSaveButton, style: TextStyle(color: Colors.white)),
                        onPressed: _submit,
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      addLink(_targetCollectionId, Link(url: _linkInputController.text.trim(), description: _descriptionInputController.text)).then((_) {
        if (widget.linkData == null || widget.linkData.isEmpty) {
          setLastActiveCollection(_targetCollectionId);
        }
        Navigator.of(context).pushReplacementNamed(CollectionsPage.routeName, arguments: {'collectionId': _targetCollectionId});
      }).catchError((e) {
        FLog.error(text: Strings.errorAddLink, exception: e);
        showSnackbar(Strings.errorAddLink);
      });
    }
  }
}
