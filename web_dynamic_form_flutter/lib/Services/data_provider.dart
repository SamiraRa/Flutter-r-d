import 'package:http/http.dart' as http;
import 'package:web_dynamic_form_flutter/Services/apis.dart';

class DataProviders {
  final String baseUrl = "";

  // DataProvider({required this.baseUrl});

  Future<http.Response> fetchData(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.get(url);
  }

  Future<http.Response> postData(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: data,
    );
  }

  Future getImageDP(int pageNumber) async {
    var param = "page=$pageNumber&per_page=30&client_id=xQPZiR8pze-Hs1VkZRm3Pu93CBM4r4235qkjXqOjbWc";

    http.Response response;
    response = await http.get(
      Uri.parse(Apis().imageApi(param)),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
    );

    return response;
  }
}
