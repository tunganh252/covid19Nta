import 'dart:convert';

import 'package:covid19nta/services/api.dart';
import 'package:http/http.dart' as http;

class APIService {
  APIService({required this.api});
  final API api;

  Future<String> getAccessToken() async {
    final response = await http.post(
      api.tokenUri(),
      headers: {"Authorization": 'Basic ${api.apiKey}'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['accessToken'];

      if (accessToken != null) {
        return accessToken;
      }
    }
    print(
        "Request ${api.tokenUri()} failed\nResponse: ${response.statusCode} ${response.reasonPhrase}");
    throw response;
  }
}
