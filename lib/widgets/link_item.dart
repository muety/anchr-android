import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/models/types.dart';
import 'package:anchr_android/resources/strings.dart';
import 'package:anchr_android/utils.dart';
import 'package:anchr_android/widgets/delete_link_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LinkItem extends StatelessWidget {
  final Link link;
  final DeleteLink deleteLink;

  LinkItem({this.link, this.deleteLink});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(link.description.isEmpty ? Strings.labelNoLinkDescription : link.description,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              subtitle: Text(
                link.url,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => Utils.launchURL(link.url),
              onLongPress: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text(Strings.labelDeleteButton),
                              onTap: () => showDialog(
                                  context: context,
                                  builder: DeleteLinkDialog(
                                    link: link,
                                    onDelete: deleteLink,
                                  ).builder)),
                          ListTile(
                              leading: const Icon(Icons.content_copy),
                              title: const Text(Strings.labelCopyButton),
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: link.url));
                                Fluttertoast.showToast(msg: Strings.msgLinkCopied);
                                Navigator.pop(context);
                              })
                        ],
                  )),
            )),
      ],
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }
}
