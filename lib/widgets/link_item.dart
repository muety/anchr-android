import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/models/types.dart';
import 'package:anchr_android/utils.dart';
import 'package:anchr_android/widgets/delete_link_dialog.dart';
import 'package:flutter/material.dart';

class LinkItem extends StatelessWidget {
  final Link link;
  final DeleteLink deleteLink;

  LinkItem({this.link, this.deleteLink});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
          children: <Widget>[
            Expanded(
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(link.description.isEmpty ? '<no description>' : link.description),
                  ),
                  subtitle: Text(
                    link.url,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => Utils.launchURL(link.url),
                )
            ),
            Padding(
              child: ButtonTheme(
                  child: FlatButton(
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 24,
                    ),
                    onPressed: () => showDialog(
                        context: context,
                        builder: DeleteLinkDialog(
                          link: link,
                          onDelete: deleteLink,
                        ).builder
                    ),
                  ),
                  minWidth: 24
              ),
              padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.end,
        )
    );
  }
}
