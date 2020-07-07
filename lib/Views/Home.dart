
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:xyapp/CustomWidgets/CustomFlatButton.dart';
import 'package:xyapp/CustomWidgets/CustomTextField.dart';
import 'package:xyapp/size_config.dart';
import 'package:photo_manager/photo_manager.dart';
class Refreshable {
  void updateTextCounter(int length) {}
  void updateView(int viewIndicator){}
}
class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> implements Refreshable{
  TextEditingController _counterTextController  = new TextEditingController();
  TextEditingController _xTextController  = new TextEditingController();
  TextEditingController _yTextController  = new TextEditingController();

  List<Widget> _mediaList = [];
  int currentPage = 0;
  int lastPage;

  int textLength;
  String xSide, ySide;
  int _viewIndicator;
  bool _showCancel;
  @override
  void initState() {
    super.initState();
    textLength = 0;
    _viewIndicator = 0;
    _showCancel = false;
  }
  @override
  void dispose() {
    super.dispose();
  }
  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async{
    var result = await PhotoManager.requestPermission();
    if(result){
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true);
      print(albums);
      List<AssetEntity> media = await albums[0].getAssetListPaged(currentPage, 60);
      print(media);
      List<Widget> temp = [];
      for(var asset in media){
        temp.add(
          FutureBuilder(
            future: asset.thumbDataWithSize(200, 200),
            builder: (BuildContext context, snapshot){
              if(snapshot.connectionState == ConnectionState.done)
                return Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.memory(
                        snapshot.data,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              return Container();
            },
          ),
        );
      }
      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    }else{
      PhotoManager.openSetting();
    }
  }
  void updateView(int viewIndicator){
    if(viewIndicator == 2){
      setState(() {
        xSide = _xTextController.text;
        textLength = 0;
        _viewIndicator = 2;
      });
    }
    if(viewIndicator == 3){
      setState(() {
        ySide = _yTextController.text;
        textLength = 0;
        _viewIndicator = 3;
      });
    }
    if(viewIndicator == 4){
      _fetchNewMedia();
      setState(() {
        _viewIndicator = 4;
      });
    }

}
  void updateTextCounter(int length){
    setState(() {
      this.textLength = length;
      if(_viewIndicator == 2){
        _showCancel = true;
        if(length<=0){
          _showCancel = false;
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    switch (_viewIndicator){
      case 0:
        return Scaffold(
          appBar: showDefaultAppbar(),
          body: defaultView(),
          endDrawer: createDrawer(),
          endDrawerEnableOpenDragGesture: false,
        );
      case 1:
        return Scaffold(
          appBar: showXappBar(),
          body: askXview(),
          endDrawer: createDrawer(),
          endDrawerEnableOpenDragGesture: false,
        );
      case 2:
        return Scaffold(
          appBar: showYappBar(),
          body: askYview(),
          endDrawer: createDrawer(),
          endDrawerEnableOpenDragGesture: false,
        );
      case 3:
        return Scaffold(
          appBar: showXappBar(),
          body: askXYview(),
          endDrawer: createDrawer(),
          endDrawerEnableOpenDragGesture: false,
        );
      case 4:
        return Scaffold(
          appBar: showXappBar(),
          body: askXview(),
          endDrawer: createDrawer(),
          endDrawerEnableOpenDragGesture: false,
        );
      default:
        return Text("Something went wrong");
    }
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
              hint: xSide,
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
            _viewIndicator = 1;
          });
        },
      ),
    );
  }
  askXYview() {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: ListView(
        children: <Widget>[
          SizedBox(height: 50.0,),
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0,top: 20.0),
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("X"),
                    Container(
                        width: 150.0,
                        child: CustomTextField(
                          hint: xSide,
                          maxLines: 5,
                          fontSized: 12.0,
                        )
                    ),
                  ],
                ),
                SizedBox(width: 50.0,),
                Column(
                  children: <Widget>[
                    Text("Y"),
                    Container(
                        width: 150.0,
                        child: CustomTextField(
                          hint: ySide,
                          maxLines: 5,
                          fontSized: 12.0,
                        )
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            child: Center(
              child: Text("____________"),
            ),
          ),
          SizedBox(height: 10.0,),
          Container(
            child: Center(
              child: Text("awaiting moderators approval",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0
                ),),
            ),
          ),
          SizedBox(height: 20.0,),
          SpinKitFadingCircle(
            color: Colors.black,
            size: 200.0,
          )
        ],
      ),
    );
  }
  askXview() {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          Container(
            //color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
              ],
            ),
          ),
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
                  viewIndicator: 4,
                  parentView: this,
                  text: "upload",
                  textAlign: TextAlign.start,
                ),
                SizedBox(width: 70.0,),
                CustomFlatButton(
                  text: "submit",
                  viewIndicator: 2,
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
          ),
          (_viewIndicator == 4) ?  Container(
            height: 300.0,
            width: 100.0,
            child:  NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scroll){
                return;
              },
              child: GridView.builder(
                itemCount: _mediaList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index){
                  return _mediaList[index];
                },
              ) ,
            ),
          ) : Text("")

        ],
      ),
    );
  }
  askYview() {
    _xTextController.text = "";
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: ListView(
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
                      controller: _yTextController,
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
                        viewIndicator: 3,
                        parentView: this,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 70.0,),
                      (_showCancel) ?
                      CustomFlatButton(
                        text: "cancel",
                        parentView: this,
                        textAlign: TextAlign.center,
                      ) : Text(""),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
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
