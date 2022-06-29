import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'disclaimercontroller.dart';

class ControllerHelper {


  static Widget buildBottomNavigationBar(BuildContext context){
    return BottomAppBar(

      child: RaisedButton(
        color: Colors.amber,
        textColor: Colors.white,
        child: Text('Disclaimer'),
        onPressed: (){
          navigateDisclaimer(context);
        },
      ),

    );
  }

  static void navigateDisclaimer(BuildContext context) async{
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => DiscliamerController())
    );
  }
}
