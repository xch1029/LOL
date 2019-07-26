class HeroDetailModel {
  String id;
  String key;
  String name;
  String title;
  List tags;
  Map image;
  List skins;
  Info info;
  List spells;
  Map passive;
  String lore;
  List allytips;
  List enemytips;

  HeroDetailModel({
    this.id,
    this.key,
    this.name,
    this.title,
    this.tags,
    this.image,
    this.skins,
    this.info,
    this.spells,
    this.passive,
    this.lore,
    this.allytips,
    this.enemytips,
  });

  HeroDetailModel.fromJson(Map json) {
    id = json['id'];
    key = json['key'];
    name = json['name'];
    title = json['title'];
    tags = json['tags'];
    image = json['image'];
    skins = json['skins'];
    info = Info.fromJson(json['info']);
    spells = json['spells'];
    passive = json['passive'];
    lore = json['lore'];
    allytips = json['allytips'];
    enemytips = json['enemytips'];
  }
}

// Hero属性
class Info {
  num attack;
  num defense;
  num magic;
  num difficulty;

  Info({this.attack, this.defense, this.magic, this.difficulty});

  Info.fromJson(Map json) {
    attack = json['attack'];
    defense = json['defense'];
    magic = json['magic'];
    difficulty = json['difficulty'];
  }
}

// 
