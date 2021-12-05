import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/models/types.dart';
import 'package:anchr_android/resources/strings.dart';
import 'package:flutter/material.dart';

class DeleteLinkDialog extends AlertDialog {
  final Link link;
  final DeleteLink onDelete;

  DeleteLinkDialog({this.link, this.onDelete});

  WidgetBuilder get builder => build;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(Strings.titleDeleteLinkDialog),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[const Text(Strings.msgConfirmDeleteLink)],
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
            onDelete(link);
            Navigator.of(context).popUntil((r) => r is MaterialPageRoute);
          },
        ),
      ],
    );
  }
}
