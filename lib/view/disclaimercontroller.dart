import 'package:flutter/material.dart';
class DiscliamerController extends StatefulWidget {

  @override
  _DiscliamerControllerState createState() => _DiscliamerControllerState();
}



class _DiscliamerControllerState extends State<DiscliamerController> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Disclaimer'),
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