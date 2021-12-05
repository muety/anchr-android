import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/models/types.dart';
import 'package:anchr_android/resources/assets.dart';
import 'package:anchr_android/resources/strings.dart';
import 'package:anchr_android/widgets/link_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LinkList extends StatelessWidget {
  final List<Link> links;
  final DeleteLink deleteLink;

  const LinkList({Key key, this.links, this.deleteLink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (links == null || links.isEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          SvgPicture.asset(
            Assets.iconNoContent,
            width: 200,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(Strings.labelNoData),
          )
        ]),
      );
    }

    return ListView(
      children: links
          .map((l) => LinkItem(
                link: l,
                deleteLink: deleteLink,
              ))
          .toList(),
    );
  }
}
