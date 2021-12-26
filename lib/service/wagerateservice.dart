import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:sectorworkingcondition/model/wagerate.dart';
import 'package:sectorworkingcondition/model/globals.dart';



class WageRateService{

  Future<List<WageRateResultSet>> fetchEntityList(int id) async{
    List<WageRateResultSet> resultList = new List<WageRateResultSet>();
    var queryParameters = {
      'Id':id.toString(),
    };
    var url = new Uri(scheme: Globals.scheme,
      host: Globals.apiHost,
      path: HttpUrl.taskgrade,
      queryParameters:queryParameters
    );

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      Iterable json = convert.jsonDecode(response.body);
      resultList = json.map((model)=> WageRateResultSet.fromJson(model)).toList();

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