import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/widgets/link_item.dart';
import 'package:flutter/material.dart';

class LinkList extends StatelessWidget {
  final List<Link> links;

  const LinkList({Key key, this.links}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (links == null || links.isEmpty) {
      return Text('No Data');
    }

    return ListView(
      children: links.map((l) => LinkItem(link: l)).toList(),
    );
  }
}