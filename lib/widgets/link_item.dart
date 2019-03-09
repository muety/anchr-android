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
    return Row(
      children: <Widget>[
        Expanded(
            child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(link.description.isEmpty ? '<no description>' : link.description,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                subtitle: Text(
                  link.url,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => Utils.launchURL(link.url),
                onLongPress: () => showMenu(
                            context: context,
                            items: <PopupMenuEntry>[
                              PopupMenuItem(
                                value: 0,
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.delete),
                                    Text("Delete"),
                                  ],
                                ),
                              ),
                            ],
                            position: buttonMenuPosition(context))
                        .then((val) {
                          if (val == 0) {
                            showDialog(
                                context: context,
                                builder: DeleteLinkDialog(
                                  link: link,
                                  onDelete: deleteLink,
                                ).builder);
                          }
                    }))),
      ],
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }

  RelativeRect buttonMenuPosition(BuildContext c) {
    final RenderBox bar = c.findRenderObject();
    final RenderBox overlay = Overlay.of(c).context.findRenderObject();
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        bar.localToGlobal(bar.size.topCenter(Offset.fromDirection(0)), ancestor: overlay),
        bar.localToGlobal(bar.size.topCenter(Offset.fromDirection(0)), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    return position;
  }
}
