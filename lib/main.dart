
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xyapp/Views/Home.dart';
import 'package:xyapp/Views/SignUp.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        //body: SignUp(),
        body: Home(),
      ),
    );

  }
}
