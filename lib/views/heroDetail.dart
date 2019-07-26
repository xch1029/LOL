import 'package:flutter/material.dart';
import 'package:lol/utils/api.dart' as api;
import 'package:lol/models/heroSimple.dart';
import 'package:lol/models/heroDetail.dart';
import 'package:lol/utils/utils.dart';
import 'package:lol/widgets/detail/detailItem.dart';

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
                  Image.network(
                    Utils.getHeroSkin(_heroData.skins[0]['id']),
                    fit: BoxFit.cover,
                  ),
                  DetailItem(
                    title: '皮肤',
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _heroData.skins
                            .map(
                              (skin) =>
                                  Image.network(Utils.getHeroSkin(skin['id']), height: 150,),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  DetailItem(
                    title: '类型',
                    child: Row(
                        children: _heroData.tags
                            .map((tag) => Text(Utils.heroTagsMap(tag)))
                            .toList()),
                  ),
                  DetailItem(
                    title: '属性',
                    child: Column(children: [
                      Text(_heroData.info.attack.toString()),
                      Text(_heroData.info.defense.toString()),
                      Text(_heroData.info.magic.toString()),
                      Text(_heroData.info.difficulty.toString()),
                    ]),
                  ),
                  DetailItem(
                    title: '使用技巧',
                    child: Column(
                      children:
                          _heroData.allytips.map((tip) => Text(tip)).toList(),
                    ),
                  ),
                  DetailItem(
                    title: '对抗技巧',
                    child: Column(
                      children:
                          _heroData.enemytips.map((tip) => Text(tip)).toList(),
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
