
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
  List<int> imageId = [];
  int currentPage = 0;
  int lastPage;
  int _imageControllerX, _imageControllerY, _selectedImageControllerX, _selectedImageControllerY;

  int textLength;
  String xSide, ySide;
  int _viewIndicator;
  bool _showCancel, _isImagesDisplayedX, _isImagesDisplayedY;
  @override
  void initState() {
    super.initState();
    textLength = 0;
    _viewIndicator = 0;
    _showCancel = false;
    _imageControllerX = 0;
    _imageControllerY = 0;
    _isImagesDisplayedX = false;
    _isImagesDisplayedY =false;
    _fetchNewMedia();
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
    if(viewIndicator == 1){    //shows ask X
      setState(() {
        _viewIndicator = 1;
      });
    }
    if(viewIndicator == 2){    //shows ask Y
      if(_xTextController.text == ""){
        print("No inputted");
        final snackBar = SnackBar(
          content: Text('No question inputted!'),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }else{
        setState(() {
          xSide = _xTextController.text;
          textLength = 0;
          _viewIndicator = 2;
        });
      }
    }
    if(viewIndicator == 3){     //shows ask X and ask Y
      if(_yTextController.text == ""){
        final snackBar = SnackBar(
          content: Text('No question inputted!'),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }else{
        setState(() {
          ySide = _yTextController.text;
          textLength = 0;
          _viewIndicator = 3;
        });
      }
    }
    if(viewIndicator == 4){   // upload is tapped shows images from ask X view
      if(_isImagesDisplayedX){  //if true hides images
        setState(() {
          _viewIndicator = 1;
          _isImagesDisplayedX = false;
        });
      }else{       //displays images
        setState(() {
          _selectedImageControllerX = 0;
          _imageControllerX = 0;
          _viewIndicator = 4;
          _isImagesDisplayedX = true;
        });
      }
    }
    if(viewIndicator == 5){   // upload is tapped shows images from ask Y view
      if(_isImagesDisplayedY){ // if true hides images
        setState(() {
          _viewIndicator = 2;
          _isImagesDisplayedY = false;
        });
      }else{              //displays images
        setState(() {
          _selectedImageControllerY = 0;
          _imageControllerY = 0;
          _viewIndicator = 5;
          _isImagesDisplayedY = true;
        });
      }
    }
    if(viewIndicator == 6){   // when +1 is press, select image as X value
     if(_xTextController.text == ""){
       print("No question inputted");
       final snackBar = SnackBar(
         content: Text('No question inputted!'),
       );
       Scaffold.of(context).showSnackBar(snackBar);
     }else{
       setState(() {
         xSide = _xTextController.text;
         _imageControllerX = 0;
         _selectedImageControllerX = null;
         _viewIndicator = 6;
       });
     }
    }
    if(viewIndicator == 7){   // select image as Y value
      if(_selectedImageControllerX == null){
        print("No image selected");
        final snackBar = SnackBar(
          content: Text('No image selected!'),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }else{
        setState(() {
          xSide = _xTextController.text;
          _selectedImageControllerY = null;
          _imageControllerY = 0;
          _viewIndicator = 7;
        });
      }
    }
    if(viewIndicator == 8){   //shows ask X and ask Y with images
     if(_selectedImageControllerY == null){
       print("No image selected for Y value");
       final snackBar = SnackBar(
         content: Text('No image selected!'),
       );
       Scaffold.of(context).showSnackBar(snackBar);
     }else{
       setState(() {
         xSide = _xTextController.text;
         _viewIndicator = 8;
       });
     }
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
        return Scaffold(             //show default view
          appBar: showDefaultAppbar(),
          body: defaultView(),
          endDrawer: createDrawer(),
          endDrawerEnableOpenDragGesture: false,
        );
      case 1:                      //shows ask X
        return Scaffold(
          appBar: showXappBar(),
          body: askXview(),
          endDrawer: createDrawer(),
          endDrawerEnableOpenDragGesture: false,
        );
      case 2:                      //shows ask Y
        return Scaffold(
          appBar: showYappBar(),
          body: askYview(),
          endDrawer: createDrawer(),
          endDrawerEnableOpenDragGesture: false,
        );
      case 3:               //shows ask X and ask Y
        return Scaffold(
          appBar: showXappBar(),
          body: askXYview(),
          endDrawer: createDrawer(),
          endDrawerEnableOpenDragGesture: false,
        );
      case 4:                // shows images from ask X
        return Scaffold(
          appBar: showXappBar(),
          body: askXview(),
          endDrawer: createDrawer(),
          endDrawerEnableOpenDragGesture: false,
        );
      case 5:                // shows images from ask Y
        return Scaffold(
          appBar: showXappBar(),
          body: askYview(),
          endDrawer: createDrawer(),
          endDrawerEnableOpenDragGesture: false,
        );
      case 6:                //update view  when +1 press on X view
        return Scaffold(
          appBar: showYappBar(),
          body: showXviewOntap_1(),
          endDrawer: createDrawer(),
          endDrawerEnableOpenDragGesture: false,
        );
      case 7:                //update view  when +1 press on Y view
        return Scaffold(
          appBar: showYappBar(),
          body: showYviewOntap_1(),
          endDrawer: createDrawer(),
          endDrawerEnableOpenDragGesture: false,
        );
      case 8:               //shows ask X and ask Y view with Images
        return Scaffold(
          appBar: showXappBar(),
          body: askXYviewImages(),
          endDrawer: createDrawer(),
          endDrawerEnableOpenDragGesture: false,
        );
      default:
        return Text("Something went wrong");
    }
  }
  askXYviewImages() {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: ListView(
        children: <Widget>[
          SizedBox(height: 50.0,),
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              children: <Widget>[
                Container(
                  height: SizeConfig.blockSizeVertical * 30,
                  width: SizeConfig.blockSizeHorizontal * 45,
                  child: _mediaList[_selectedImageControllerX],
                ),
                Container(
                  height: SizeConfig.blockSizeVertical * 30,
                  width: SizeConfig.blockSizeHorizontal * 45,
                  child: _mediaList[_selectedImageControllerY],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
           child: Text(xSide,
           textAlign: TextAlign.center,
           style: TextStyle(
             color: Colors.black26,
             fontSize: 20.0,
             fontFamily: "Helvetica"
           ),)
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
  showYviewOntap_1() {
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
                Container(
                  child: Row(
                    children: <Widget>[
                      CustomFlatButton(
                        text: "cancel",
                        parentView: this,
                        viewIndicator: 1,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 50,
                      ),
                      CustomFlatButton(
                        text: "next",
                        viewIndicator: 8,
                        parentView: this,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  height: SizeConfig.blockSizeVertical * 30,
                  width: SizeConfig.screenWidth,
                  child: _mediaList[_imageControllerY],
                ),
              ],
            ),
          ),
          Container(
            //padding: EdgeInsets.only(top: 20.0),
            height: 100.0,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 45,
                ),
                Container(
                  height: 50.0,
                  width: 100.0,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26)
                        ),
                        child: (_selectedImageControllerY!=null)? _mediaList[_selectedImageControllerY] : null,
                      ),
                      Positioned(
                        left: 10.0,
                        top: 10.0,
                        child:  Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black26)
                          ),
                          child: (_selectedImageControllerX!=null)? _mediaList[_selectedImageControllerX] : null,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomFlatButton(
                  text: "+1",
                  parentView: this,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            height: 300.0,
            //width: 100.0,
            child:  NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scroll){
                return;
              },
              child: GridView.builder(
                itemCount: _mediaList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index){
                  if(_selectedImageControllerX == index){
                    return Center(
                      child: Text("X",
                        style: TextStyle(
                            fontFamily: "Helvetica",
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0
                        ),),
                    );
                  }else{
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedImageControllerY = index;
                          _imageControllerY = index;
                        });
                      },
                      child: (_selectedImageControllerY == index) ?
                      Center(
                        child: Text("Y",
                          style: TextStyle(
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0
                          ),),
                      ) : Container(
                        child: _mediaList[index],
                      ),
                    );
                  }
                },
              ) ,
            ),
          )
        ],
      ),
    );
  }
  showXviewOntap_1() {
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
                Container(
                  child: Row(
                    children: <Widget>[
                      CustomFlatButton(
                        text: "cancel",
                        parentView: this,
                        viewIndicator: 1,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 50,
                      ),
                      CustomFlatButton(
                        text: "next",
                        viewIndicator: 7,
                        parentView: this,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  height: SizeConfig.blockSizeVertical * 30,
                  width: SizeConfig.screenWidth,
                  child: _mediaList[_imageControllerX],
                ),
              ],
            ),
          ),
          Container(
            //padding: EdgeInsets.only(top: 20.0),
            height: 100.0,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 45,
                ),
                Container(
                  height: 50.0,
                  width: 100.0,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26)
                        ),
                      ),
                       Positioned(
                        left: 10.0,
                        top: 10.0,
                        child:  Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                              border: Border.all(color: Colors.black26)
                          ),
                          child: (_selectedImageControllerX!=null)? _mediaList[_selectedImageControllerX] : null,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomFlatButton(
                  text: "+1",
                  parentView: this,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            height: 300.0,
            //width: 100.0,
            child:  NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scroll){
                return;
              },
              child: GridView.builder(
                itemCount: _mediaList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index){
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedImageControllerX = index;
                        _imageControllerX = index;
                      });
                    },
                    child: (_selectedImageControllerX == index) ?
                    Center(
                      child: Text("X",
                      style: TextStyle(
                        fontFamily: "Helvetica",
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0
                      ),),
                    ) : Container(
                      child: _mediaList[index],
                    ),
                  );
                },
              ) ,
            ),
          )
        ],
      ),
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
      child: Text("X/Y",
      style: TextStyle(
        fontFamily: "AppleGothic",
        color: Colors.black
      ),)
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
              child: Text("X/Y",
                style: TextStyle(
                    fontFamily: "AppleGothic",
                    color: Colors.black
                ),)
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
        child: Text("X/Y",
          style: TextStyle(
              fontFamily: "AppleGothic",
              fontSize: 100.0,
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),),
        onPressed: () {
          setState(() {
            _viewIndicator = 1;   //show case 1 ask X view
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
  askXview() {                               // _viewIndicator is 1
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
                      maxLines: 10,
                      maxLength: 2000,
                      fontSized: 20.0,
                    )),
                Center(
                  child: (_viewIndicator == 4) ?
                  Container(
                    height: SizeConfig.blockSizeVertical * 20,
                    width: SizeConfig.blockSizeHorizontal * 80,
                    child: _mediaList[_imageControllerX],
                  ) : Container(),
                )
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
                  viewIndicator: 6,
                  parentView: this,
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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index){
                  //imageId.add(index);
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedImageControllerX = index;
                        _imageControllerX = index;
                      });
                    },
                    child: (_selectedImageControllerX == index) ?
                    Center(
                      child: Text("X",
                        style: TextStyle(
                            fontFamily: "Helvetica",
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0
                        ),),
                    ) : Container(
                      child: _mediaList[index],
                    ),
                  );
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
          SizedBox(
            height: 30.0,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                      maxLines: 10,
                      maxLength: 2000,
                      fontSized: 20.0,
                    )),
                Center(
                  child: (_viewIndicator == 5) ?
                  Container(
                    height: SizeConfig.blockSizeVertical * 20,
                    width: SizeConfig.blockSizeHorizontal * 80,
                    child: _mediaList[_imageControllerY],
                  ) : Container(),
                ),
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
                  viewIndicator: 5,
                  parentView: this,
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
          ),
          (_viewIndicator == 5) ?  Container(
            height: 300.0,
            width: 100.0,
            child:  NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scroll){
                return;
              },
              child: GridView.builder(
                itemCount: _mediaList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index){
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedImageControllerY = index;
                        _imageControllerY = index;
                      });
                    },
                    child: (_selectedImageControllerY == index) ?
                    Center(
                      child: Text("Y",
                        style: TextStyle(
                            fontFamily: "Helvetica",
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0
                        ),),
                    ) : Container(
                      child: _mediaList[index],
                    ),
                  );
                },
              ) ,
            ),
          ) : Text("")
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