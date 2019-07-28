import 'package:flutter/material.dart';
import 'package:lol/widgets/home/heroItem.dart';
import 'package:lol/models/heroSimple.dart';

class HomeList extends StatefulWidget {
  final List data;
  HomeList({Key key, this.data}) : super(key: key);

  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (BuildContext context, int index) {
          return HeroItem(data: HeroSimple.fromJson(widget.data[index]));
        },
      ),
    );
  }
}
