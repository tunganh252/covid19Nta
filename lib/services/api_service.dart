import 'dart:convert';

import 'package:covid19nta/services/api.dart';
import 'package:covid19nta/services/endpoint_data.dart';
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
      final accessToken = data['access_token'];

      if (accessToken != null) {
        return accessToken;
      }
    }
    print(
        "Request ${api.tokenUri()} failed\nResponse: ${response.statusCode} ${response.reasonPhrase}");
    throw response;
  }

  Future<EndpointData> getEndpointData(
      {required String accessToken,
      required Endpoint endpoint,
      String responseJsonKey = "data"}) async {
    final uri = api.endpointUri(endpoint);
    final response = await http.get(
      uri,
      headers: {"Authorization": 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final Map<String, dynamic> endpointData = data[0];
        final int value = endpointData[responseJsonKey];
        final String dateString = endpointData["date"];
        final dateTime = DateTime.tryParse(dateString);

        if (value >= 0) {
          return EndpointData(value: value, dateTime: dateTime);
        }
      }
    }
    print(
        "Request ${api.endpointUri(endpoint)} failed\nResponse: ${response.statusCode} ${response.reasonPhrase}");
    throw response;
  }
}
