import 'package:flutter/material.dart';
import 'package:lol/utils/api.dart' as api;
import 'package:lol/widgets/home/heroItem.dart';
import 'package:lol/models/heroSimple.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<dynamic> heroList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    Map res = await api.getHeroList();
    setState(() {
     heroList = res.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: heroList.length,
          itemBuilder: (BuildContext context, int index) {
            return HeroItem(data: HeroSimple.fromJson(heroList[index]));
          },
        ),
      ),
    );
  }
}
