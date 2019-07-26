class HeroSimple {
  String id;
  String key;
  String name;
  String title;
  List tags;
  Map image;

  HeroSimple({this.id,this.key,this.name,this.title,this.tags,this.image});

  HeroSimple.fromJson(Map json) {
    id = json['id'];
    key = json['key'];
    name = json['name'];
    title = json['title'];
    tags = json['tags'];
    image = json['image'];
  }
}