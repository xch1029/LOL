import 'package:lol/utils/constant.dart';
class Utils {
  // 英雄标签
  static heroTagsMap(tag) {
    return {
      'Fighter': '战士',
      'Tank': '坦克',
      'Mage': '法师',
      'Assassin': '刺客',
      'Support': '辅助',
      'Marksman': '射手',
    }[tag];
  }
  // 获取英雄头像
  static getHeroAvatar(image) => '${Constant.imgBaseUrl}/img/champion/$image';
  // 获取英雄皮肤大图
  static getHeroSkin(id) => '${Constant.imgBaseUrl}/web201310/skin/big$id.jpg';
}