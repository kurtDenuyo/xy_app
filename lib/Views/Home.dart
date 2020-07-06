import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xyapp/CustomWidgets/CustomFlatButton.dart';
import 'package:xyapp/CustomWidgets/CustomTextField.dart';
class Refreshable {
  void updateTextCounter(int length) {}
  void updateView(){}
}
class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> implements Refreshable{
  bool _showDefaultView, _showAskView;
  TextEditingController _counterTextController  = new TextEditingController();
  TextEditingController _xTextController  = new TextEditingController();
  int textLength;
  String xSide;
  @override
  void initState() {
    super.initState();
    _showDefaultView = true;
    _showAskView = false;
    textLength = 0;
  }
void updateView(){
    setState(() {
      _showDefaultView = false;
      _showAskView = false;
      xSide = _xTextController.text;
      textLength = 0;

    });
}
  void updateTextCounter(int length){
    setState(() {
      this.textLength = length;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (!_showDefaultView) ? ((_showAskView) ? showXappBar() : showYappBar()) : showDefaultAppbar(),
      body: (!_showDefaultView) ? ((_showAskView) ? showAsk_X() : showAsk_Y()) : defaultView(),
      endDrawer: createDrawer(),
      endDrawerEnableOpenDragGesture: false,
    );
  }
showDefaultAppbar(){
  return AppBar(
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    actions: [
      Builder(
        builder: (context) => IconButton(
          icon: Image.asset(
            "assets/images/user.png",
            fit: BoxFit.contain,
          ),
          onPressed: () => Scaffold.of(context).openEndDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
      ),
    ],
  );
}
showXappBar(){
  return AppBar(
    centerTitle: true,
    title: Container(
      height: 20.0,
      child: Image.asset(
        "assets/images/logo.png",
        fit: BoxFit.contain,
      ),
    ),
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    actions: [
      Builder(
        builder: (context) => IconButton(
          icon: Image.asset(
            "assets/images/user.png",
            fit: BoxFit.contain,
          ),
          onPressed: () => Scaffold.of(context).openEndDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
      ),
    ],
  );
}
  showYappBar(){
    return AppBar(
      centerTitle: true,
      title: Container(
        child: Row(children: [
          Container(
            width: 150.0,
            child: CustomTextField(
              hint: _xTextController.text,
              maxLines: 2,
              maxLength: 40,
              fontSized: 12.0,
            )
          ),
          Center(
            child: Container(
              height: 20.0,
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
              ),
            ),
          )
        ]),
      ),
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      actions: <Widget>[
        Builder(
          builder: (context) => IconButton(
            icon: Image.asset(
              "assets/images/user.png",
              fit: BoxFit.contain,
            ),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        ),
      ],
    );
  }
  defaultView() {
    return Center(
      child: new FlatButton(
        child: Image.asset(
          "assets/images/logo.png",
          fit: BoxFit.contain,
        ),
        onPressed: () {
          setState(() {
            _showDefaultView = false;
            _showAskView = true;
          });
        },
      ),
    );
  }

  showAsk_X() {
    return ListView(
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Center(
                child: Text("X"),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                  child: CustomTextField(
                    controller: _xTextController,
                    parentView: this,
                hint: "Ask me...",
                maxLines: 12,
                    maxLength: 2000,
                    fontSized: 20.0,
              )),
              Container(
                  padding: EdgeInsets.only(left: 20.0),
                child: Text(textLength.toString()+"/2000",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black26,
                    )),
              ),
              Container(
                padding: EdgeInsets.all(0.0),
                child: Row(
                  children: <Widget>[
                    CustomFlatButton(
                      text: "upload",
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(width: 70.0,),
                    CustomFlatButton(
                      text: "submit",
                      parentView: this,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 70.0,),
                    CustomFlatButton(
                      text: "+1",
                      textAlign: TextAlign.right,
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
  showAsk_Y() {
    _xTextController.text = "";
    return ListView(
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Center(
                child: Text("Y"),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                  child: CustomTextField(
                    parentView: this,
                    hint: "Ask me...",
                    maxLines: 12,
                    maxLength: 2000,
                    fontSized: 20.0,
                  )),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(textLength.toString()+"/2000",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black26,
                    )),
              ),
              Container(
                padding: EdgeInsets.all(0.0),
                child: Row(
                  children: <Widget>[
                    CustomFlatButton(
                      text: "upload",
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(width: 70.0,),
                    CustomFlatButton(
                      text: "submit",
                      parentView: this,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 70.0,),
                    CustomFlatButton(
                      text: "+1",
                      textAlign: TextAlign.right,
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  createDrawer() {
    return Drawer(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('This is the Drawer'),
            RaisedButton(
              onPressed: _closeEndDrawer,
              child: const Text('Close Drawer'),
            ),
          ],
        ),
      ),
    );
  }
}
