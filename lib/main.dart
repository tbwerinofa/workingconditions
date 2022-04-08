import 'package:cbatracker/view/dashboardcontroller.dart';
import 'package:cbatracker/view/introcontroller.dart';
import 'package:cbatracker/view/mysharedpreferenceutil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

  runApp(MyApp());
}

class MyAppLegacy extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
      ),
      home: new FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                       return new IntroController();
                default:
                        if (!snapshot.hasError) {
                        return snapshot.data.getBool("welcome") != null
                        ? new DashBoardController()
                            : new IntroController();
                        } else {
                        //return new ErrorScreen(error: snapshot.error);
                          return new IntroController();
                        }
          }
    }),
    );
  }

  StatefulWidget LoadController()
  {
    return new FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new IntroController();
          default:
            if (!snapshot.hasError) {
        return snapshot.data.getBool("welcome") != null
        ? new DashBoardController()
            : new IntroController();
        } else {
        //return new ErrorScreen(error: snapshot.error);
        }
      }
      },
    );
  }
}


class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}
class MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  bool isLoggedIn = false;

  MyAppState() {
    MySharedPreferences.instance
        .getBooleanValue("isfirstRun")
        .then((value) => setState(() {
      isLoggedIn = value;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sector Working Conditions',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: isLoggedIn ? DashBoardController() : IntroController());
  }
}