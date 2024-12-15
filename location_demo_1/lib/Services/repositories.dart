import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location_demo_1/Services/data_provider.dart';

class Repository {
  Future<List> locationRepo(
    String tracking,
    String lat,
    String long,
    String address,
    String trackingOn,
    String note,
  ) async {
    List a = [];
    try {
      http.Response response = await DataProvider().locationDP(tracking, lat, long, address, trackingOn, note);
      var responseData = jsonDecode(response.body);
      print(responseData);
      a = responseData;
      return responseData;
    } on Exception catch (e) {
      // throw Exception(e);
      debugPrint(e.toString());
    }
    return a;
  }
}
