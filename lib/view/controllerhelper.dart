import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'disclaimercontroller.dart';

class ControllerHelper {


  static Widget buildBottomNavigationBar(BuildContext context){
    return BottomAppBar(

      child: ElevatedButton(
        onPressed: (){
          navigateDisclaimer(context);
        },
        child: Text('Disclaimer'),
        //color: Colors.amber,
       // textColor: Colors.white,
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.amber,
            padding:
            const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            textStyle:
            const TextStyle(backgroundColor: Colors.amber,color:Colors.white,fontSize: 30, fontWeight: FontWeight.bold)),

      ),

    );
  }

  static void navigateDisclaimer(BuildContext context) async{
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => DiscliamerController())
    );
  }
}
