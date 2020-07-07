
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xyapp/Views/Home.dart';

class CustomFlatButton extends StatelessWidget {

  CustomFlatButton(
      {
      this.text,
        this.textAlign,
        this.parentView,
        this.fromYview,
        this.viewIndicator
      });
  String text;
  var textAlign, viewIndicator;
  bool fromYview;
  Refreshable parentView;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 14.0,
        color: Colors.black26
      ),),
      onPressed: ()
      {
        this.parentView.updateView(viewIndicator);
      },
    );
  }
}