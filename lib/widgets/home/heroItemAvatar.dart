import 'package:flutter/material.dart';

class HeroItemAvatar extends StatefulWidget {
  final img;
  HeroItemAvatar({Key key, @required this.img}) : super(key: key);

  _HeroItemAvatarState createState() => _HeroItemAvatarState();
}

class _HeroItemAvatarState extends State<HeroItemAvatar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            offset: new Offset(0.0, 0.0),
            blurRadius: 3.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      width: 80,
      height: 80,
      child: Padding(
        padding: EdgeInsets.all(4),
        child: CircleAvatar(
          backgroundImage: NetworkImage(widget.img),
        ),
      ),
    );
  }
}
