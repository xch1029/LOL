import 'package:flutter/material.dart';

class DetailItem extends StatelessWidget {
  final String title;
  final Widget child;
  const DetailItem({Key key, this.title, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title),
        child
      ],
    );
  }
}
