import 'package:SoftrigFlutter/screens/login/login_form.dart';
import 'package:flutter/material.dart';



void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Token token;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/', routes: {
      '/': (context) => LoginScreen(),
    });
  }
}
