import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:location_demo_1/Services/apis.dart';

class DataProvider {
  Future<http.Response> locationDP(
      String tracking, String lat, String long, String address, String trackingOn, String note) async {
    http.Response response = await http.post(
      Uri.parse(Apis().locationApi),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, dynamic>{
          "tracking": tracking,
          "latitude": lat,
          "longitude": long,
          "address": address,
          "tracking_on": trackingOn,
          "note": note
        },
      ),
    );
    return response;
  }
}
