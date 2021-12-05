import 'package:anchr_android/models/link_collection.dart';
import 'package:anchr_android/models/types.dart';
import 'package:anchr_android/resources/strings.dart';
import 'package:flutter/material.dart';

class DeleteCollectionDialog extends AlertDialog {
  final LinkCollection collection;
  final DeleteCollection onDelete;

  DeleteCollectionDialog({this.collection, this.onDelete});

  WidgetBuilder get builder => build;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(Strings.titleDeleteCollectionDialog),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[const Text(Strings.msgConfirmDeleteCollection)],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(Strings.labelCancelButton),
          onPressed: () {
            Navigator.of(context).popUntil((r) => r is MaterialPageRoute);
          },
        ),
        TextButton(
          child: const Text(Strings.labelYesButton),
          onPressed: () {
            onDelete(collection);
            Navigator.of(context).popUntil((r) => r is MaterialPageRoute);
          },
        ),
      ],
    );
  }
}
