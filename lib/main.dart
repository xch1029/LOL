import 'package:flutter/material.dart';
import 'package:lol/utils/router.dart' as router;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.grey[100],
    accentColor: Colors.blueAccent,
    backgroundColor: Colors.grey[100],
    scaffoldBackgroundColor: Colors.grey[100],
    textTheme: TextTheme(
      headline: TextStyle(),
      title: TextStyle(),
      body1: TextStyle(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOL',
      theme: light,
      onGenerateRoute: router.generateRoute,
      initialRoute: '/',
    );
  }
}
