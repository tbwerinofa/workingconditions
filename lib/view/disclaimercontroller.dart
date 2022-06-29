import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';


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
      body:BuildDiclaimer()
    );
  }

  Widget BuildDiclaimer(){
    return  SingleChildScrollView(
      child:Container(margin: EdgeInsets.all(5),
      child: Html(
        data: htmlData,
       ),
    ));
  }
  final htmlData = r"""
    <h1>SWC Tracker Disclaimer</h1>
      <hr/>
       <p style="text-align: justify;">
       <h2>INTRODUCTION</h2>
       The information provided by SWC Tracker (“we,” “us” or “our”) on this mobile application
       is for general informational purposes only. All information on the mobile application is provided in good faith,
       however we make no representation or warranty of any kind, express or implied, regarding the accuracy, adequacy,
       validity, reliability, availability or completeness of any information on our mobile application.
       </p>
       <p style="text-align: justify;">
       Under no circumstance shall we have any liability to you for any loss or damage of any kind incurred
       as a result of the use of the SWC Tracker or reliance on any information provided on 
       our mobile application. Your use of the our mobile application and your reliance on any information
       on our mobile application is solely at your own risk. 
       </p>
      <p style="text-align: justify;">
        <h2>EXTERNAL LINKS DISCLAIMER FOR WEBSITE</h2>
         SWC Tracker may contain (or you may be sent through our mobile application)
         links to other websites or content belonging to or originating from third parties
         or links to websites and features in banners or other advertising. 
         Such external links are not investigated, monitored, or checked for accuracy, adequacy,
         validity, reliability, availability or completeness by us. 
         We do not warrant, endorse, guarantee, or assume responsibility for the accuracy or reliability
         of any information offered by third-party websites linked through the site or any website or feature
          linked in any banner or other advertising. We will not be a party to or in any way be responsible for 
          monitoring any transaction between you and third-party providers of products or services.

      </p>
     
      <p style="text-align: justify;">
      <h2>Credits</h2>
      Information on this website has been gathered from the following sources, where is it publicly available
      <ol>
      <li>
       <a href='https://bccei.co.za'>Bargaining Council for the Civil Engineering Industry (BCCEI)</a> 
      </li>
      </ol>
        Please note SWC Tracker is not affliated in anyway to the data providers, 
       and any problems arising from relying on the data 
       the they will not be held liable
         </p>
    """;

}