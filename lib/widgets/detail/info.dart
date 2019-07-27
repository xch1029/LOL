import 'package:flutter/material.dart';

class HeroInfo extends StatelessWidget {
  final data;
  const HeroInfo({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List list = [
      {'title': '物理攻击', 'value': data.attack / 10, 'color': Colors.blue},
      {'title': '魔法攻击', 'value': data.magic / 10, 'color': Colors.green},
      {'title': '防御能力', 'value': data.defense / 10, 'color': Colors.yellow},
      {'title': '上手难度', 'value': data.difficulty / 10, 'color': Colors.pink},
    ];
    return Container(
      child: Column(
        children: list
            .map(
              (item) => Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Text(item['title']),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: LinearProgressIndicator(
                      value: item['value'],
                      valueColor: AlwaysStoppedAnimation(item['color']),
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 40,
                    child: Text((100 * item['value']).toString(),style: TextStyle(color: item['color']),),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
