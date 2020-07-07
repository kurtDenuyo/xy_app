
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xyapp/CustomWidgets/CustomImageCache.dart';
import 'package:xyapp/Views/Home.dart';
import 'package:xyapp/Views/SignUp.dart';
void main(){
  CustomImageCache();
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

