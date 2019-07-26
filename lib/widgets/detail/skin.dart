import 'package:flutter/material.dart';
import 'package:lol/utils/utils.dart';

class Skins extends StatelessWidget {
  final List imgList;
  const Skins({Key key, this.imgList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context, nullOk: true).size.width ?? 0;
    return Container(
      width: screenWidth,
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: imgList
            .map(
              (skin) => InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    'imagePreview',
                    arguments: Utils.getHeroSkin(skin['id']),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  width: screenWidth * 0.7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Image.network(Utils.getHeroSkin(skin['id']),
                            height: 150, width: screenWidth * 0.7),
                        Container(
                          width: screenWidth * 0.7,
                          color: Colors.grey[200].withOpacity(0.3),
                          alignment: Alignment.center,
                          height: 20,
                          child: Text(
                            skin['name'],
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
