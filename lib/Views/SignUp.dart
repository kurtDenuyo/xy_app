
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child:  new InkWell(
        onTap: () {
        },
        child: new FlatButton(
          child: const Text('sign up',
            style: TextStyle(
                fontSize: 30.0
            ),),
          textColor: Colors.black26,
          onPressed: ()
          {

          },
        ),
      ),
    );
  }
}