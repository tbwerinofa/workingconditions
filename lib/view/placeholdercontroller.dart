import 'package:flutter/material.dart';
class PlaceHolderController extends StatefulWidget {
  PlaceHolderController({this.pageTitle});
  final String pageTitle;
  @override
  _PlaceHolderControllerState createState() => _PlaceHolderControllerState(pageTitle:this.pageTitle);
}



class _PlaceHolderControllerState extends State<PlaceHolderController> {
  _PlaceHolderControllerState({this.pageTitle});
  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(pageTitle),
      ),
      body:Center(
    // Center is a layout widget. It takes a single child and positions it
    // in the middle of the parent.
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
    new Container(
    margin: EdgeInsets.all(15),
        child:Text(
          'Page Still Under development',
            style: TextStyle(color: Colors.white, fontSize: 20.0)
        )),
        new Container(
          margin: EdgeInsets.all(15),
          child: new  Image.asset('assets/undraw_under_construction.png'),
          alignment: Alignment.center,
        ),

      ],
    ),
    ),
      backgroundColor: Colors.black54,
    );
  }

}