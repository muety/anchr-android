import 'package:anchr_android/models/link_collection.dart';
import 'package:anchr_android/models/types.dart';
import 'package:anchr_android/resources/strings.dart';
import 'package:flutter/material.dart';

class AddCollectionDialog extends AlertDialog {
  final List<LinkCollection> existingCollections;
  final AddCollection onAddCollection;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String newName;

  AddCollectionDialog({this.onAddCollection, this.existingCollections});

  WidgetBuilder get builder => build;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(Strings.titleNewCollectionDialog),
      content: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  const Text(Strings.msgChooseCollectionName),
                  Row(children: <Widget>[
                    Expanded(
                        child: TextFormField(
                          autofocus: true,
                          autovalidate: true,
                          validator: (name) => _validateName(name) ? null : Strings.errorInvalidName,
                          decoration: const InputDecoration(
                            hintText: Strings.labelCollectionNameInputHint,
                            labelText: Strings.labelCollectionNameInput,
                          ),
                          onSaved: (val) => newName = val,
                    ))
                  ])
                ],
              ))),
      actions: <Widget>[
        FlatButton(
          child: const Text(Strings.labelCancelButton),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: const Text(Strings.labelAddButton),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              onAddCollection(newName);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  bool _validateName(String name) =>
      existingCollections != null && !existingCollections.any((c) => c.name == name) && name.isNotEmpty;
}
