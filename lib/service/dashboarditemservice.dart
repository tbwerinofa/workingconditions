import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:cbatracker/model/dashboardItem.dart';
import 'package:cbatracker/model/globals.dart';



class DashBoardItemService{

  Future<List<DashBoardItem>> fetchEntityList() async{
    List<DashBoardItem> resultList = new List<DashBoardItem>();
     print('call service');
    try {
      final result = await InternetAddress.lookup('52.213.36.91');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

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
          print(response.reasonPhrase);

        }
      }
    } on SocketException catch (_) {
      print('not connected');
    }
    return resultList;
  }


  static Map<String,String> headers = {
    'Content-type':'application/json',
    'Accept':'application/json'
  };
}