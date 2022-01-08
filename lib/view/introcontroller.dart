import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/slide_object.dart';

import 'dashboardcontroller.dart';

class IntroController extends StatefulWidget {
  IntroController({Key key}):super(key:key);
  @override
  _IntroControllerState createState() => _IntroControllerState();
}

class _IntroControllerState extends State<IntroController> {
  List<Slide> slides = new List();

  Function goToTab;
  @override initState() {

    slides.add(
        GenerateSlide("CBA Tracker","Innovative Insight in Action","undraw_under_construction.png")
    );
    slides.add(
        GenerateSlide("Wage Rate","Track wage rates by grade","undraw_under_construction.png")
    );
    slides.add(
        GenerateSlide("Sub-Sector Analytics","Salary vs Inflation trend insights and analysis","undraw_under_construction.png")
    );

  }

  void onDonePress(){

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DashBoardController())
    );

  }
  void onTabChangeCompleted(index){
  }

  Widget renderNextBtn(){
  return Icon(
    Icons.navigate_next,
    color: Colors.amber,
      size:35.0
  ) ;
  }

  Widget renderDoneBtn(){
    return Icon(
        Icons.done,
        color: Colors.amber,
    ) ;
  }
  Widget renderSkipBtn(){
    return Icon(
      Icons.skip_next,
      color: Colors.amber,
    ) ;
  }
List<Widget> renderListCustomTabs(){
    List<Widget> tabs = new List();

    for(int i=0;i<slides.length;i++)
      {
        Slide currentSlide =slides[i];
        tabs.add(Container(
          margin:EdgeInsets.only(bottom: 60.0,top:60.0),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                child:
                Image.asset(
                  currentSlide.pathImage,
                  width: 200.0,
                  height: 200.0,
                  fit:BoxFit.contain,
                )
              ),
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top:20.0),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top:20.0),
              )
            ],
          ),
        )
        );
      }
    return tabs;
}



  @override
  Widget build(BuildContext context) {
    return new IntroSlider(slides: this.slides,
    renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Colors.amber,
      highlightColorSkipBtn: Colors.amber,

      renderNextBtn: this.renderNextBtn(),

      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: Colors.amber,
      highlightColorDoneBtn: Colors.amber,

      colorDot:Colors.amber,
      sizeDot: 13.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

      listCustomTabs: this.renderListCustomTabs(),
      backgroundColorAllSlides: Colors.white,
      refFuncGoToTab: (refFunc){
      this.goToTab =refFunc;
      },

      hideStatusBar: true,

      onTabChangeCompleted: this.onTabChangeCompleted,



    );
  }
}

Slide GenerateSlide(String title,String description,String image){
  return new Slide(
    title:title,
    styleTitle: TextStyle(
        color: Color(0xff3da4ab),
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        fontFamily: "RobotMono"),
    description:description,
    styleDescription:TextStyle(
        color: Color(0xfffe9c8f),
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
        fontFamily: "Raleway"),
    pathImage: "assets/${image}",
  );
}