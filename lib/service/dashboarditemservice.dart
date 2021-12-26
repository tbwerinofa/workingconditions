import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:sectorworkingcondition/model/dashboardItem.dart';
import 'package:sectorworkingcondition/model/globals.dart';



class DashBoardItemService{

  Future<List<DashBoardItem>> fetchEntityList() async{
    List<DashBoardItem> resultList = new List<DashBoardItem>();

    var url = new Uri(scheme: Globals.scheme,
      host: Globals.apiHost,
      path: HttpUrl.subsector,
    );

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      Iterable json = convert.jsonDecode(response.body);
      resultList = json.map((model)=> DashBoardItem.fromObject(model)).toList();

    }
    else {
      // resp.error = response.reasonPhrase;
     // return 'error';
    }
    return resultList;
  }


  static Map<String,String> headers = {
    'Content-type':'application/json',
    'Accept':'application/json'//,
    //HttpHeaders.authorizationHeader: Globals.authorization
  };
}