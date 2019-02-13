import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/models/types.dart';
import 'package:flutter/material.dart';

class DeleteLinkDialog extends AlertDialog {
  final Link link;
  final DeleteLink onDelete;

  DeleteLinkDialog({this.link, this.onDelete});

  WidgetBuilder get builder => build;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Delete link?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const Text('Are you sure you want to delete this link from the collection?')
            ],
          ),
        ),
      actions: <Widget>[
        FlatButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: const Text('Yes'),
          onPressed: () {
            onDelete(link);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}