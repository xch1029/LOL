import 'package:flutter/material.dart';
import 'package:lol/utils/api.dart' as api;
import 'package:lol/models/heroSimple.dart';
import 'package:lol/models/heroDetail.dart';
import 'package:lol/utils/utils.dart';
import 'package:lol/widgets/detail/detailItem.dart';
import 'package:lol/widgets/detail/skin.dart';
import 'package:lol/widgets/detail/info.dart';

class HeroDetail extends StatefulWidget {
  final HeroSimple heroSimple;
  HeroDetail({Key key, this.heroSimple}) : super(key: key);

  _HeroDetailState createState() => _HeroDetailState();
}

class _HeroDetailState extends State<HeroDetail> {
  HeroDetailModel _heroData; // hero数据
  bool _loading = false; // 加载状态
  String _version = ''; // 国服版本
  String _updated = ''; // 文档更新时间

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {
      _loading = true;
    });
    Map res = await api.getHeroDetail(widget.heroSimple.id);
    var data = res['data'];
    String version = res['version'];
    String updated = res['updated'];
    print(version);
    setState(() {
      _heroData = HeroDetailModel.fromJson(data);
      _version = version;
      _updated = updated;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.heroSimple.name)),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DetailItem(
                    title: '皮肤',
                    child: Skins(imgList: _heroData.skins),
                  ),
                  DetailItem(
                    title: '类型',
                    child: Row(
                        children: _heroData.tags
                            .map((tag) => Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: CircleAvatar(
                                    child: Text(
                                      Utils.heroTagsMap(tag),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ))
                            .toList()),
                  ),
                  DetailItem(
                    title: '属性',
                    child: HeroInfo(data: _heroData.info),
                  ),
                  DetailItem(
                    title: '使用技巧',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _heroData.allytips
                          .map((tip) => Column(
                                children: <Widget>[
                                  Text(tip),
                                  SizedBox(height: 5)
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                  DetailItem(
                    title: '对抗技巧',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _heroData.enemytips
                          .map((tip) => Column(
                                children: <Widget>[
                                  Text(tip),
                                  SizedBox(height: 5)
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                  DetailItem(
                    title: '背景故事',
                    child: Text(_heroData.lore),
                  ),
                  DetailItem(
                    title: '国服版本',
                    child: Text(_version),
                  ),
                  DetailItem(
                    title: '更新时间',
                    child: Text(_updated),
                  )
                ],
              ),
            ),
    );
  }
}
