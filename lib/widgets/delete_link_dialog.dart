import 'package:anchr_android/models/link.dart';
import 'package:flutter/material.dart';

class DeleteLinkDialog extends AlertDialog {
  final Link link;
  final Function(Link link) onDelete;

  DeleteLinkDialog({this.link, this.onDelete});

  WidgetBuilder get builder => build;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Delete link?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this link from the collection?')
            ],
          ),
        ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            onDelete(link);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}