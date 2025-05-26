import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:web_dynamic_form_flutter/Services/data_provider.dart';

class Repositories {
  Future<dynamic> fetchData(String endpoint) async {
    try {
      // Simulate API call or use http package for real API calls
      // Example: final response = await http.get(Uri.parse(endpoint));
      // return response.body;

      // Placeholder for demonstration
      return {"message": "Data fetched from $endpoint"};
    } catch (e) {
      throw Exception("Failed to fetch data: $e");
    }
  }

  Future getImageRepo(pageNumber) async {
    // Map imageList = {};

    try {
      final http.Response response = await DataProviders().getImageDP(pageNumber);
      // List<UnsplashModel> imageList = unsplashModelFromJson(response.body);
      List imageList = jsonDecode(response.body);

      print("imageList ${imageList.length}");

      return imageList;
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveData(String key, dynamic value) async {
    try {
      print("Data saved: $key -> $value");
    } catch (e) {
      throw Exception("Failed to save data: $e");
    }
  }
}
