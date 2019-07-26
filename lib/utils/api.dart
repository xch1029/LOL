import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

getHeroList() async {
  var res = await http.get('http://47.52.142.157:3002/hero');
  if (res.statusCode == 200) {
    return convert.jsonDecode(res.body)['data'];
  } else {
    print("Request failed with status: ${res.statusCode}.");
  }
}

getHeroDetail(id) async {
  var res = await http.get('http://47.52.142.157:3002/hero/$id');
  if (res.statusCode == 200) {
    return convert.jsonDecode(res.body);
  } else {
    print("Request failed with status: ${res.statusCode}.");
  }
}
