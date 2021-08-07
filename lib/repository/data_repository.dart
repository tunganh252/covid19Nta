import 'package:covid19nta/repository/endpoints_data.dart';
import 'package:covid19nta/services/api.dart';
import 'package:covid19nta/services/api_service.dart';
import 'package:http/http.dart';

class DataRepository {
  DataRepository({required this.apiService});

  final APIService apiService;

  String _accessToken = "";

  Future<int> getDataEndpoint(Endpoint endpoint,
      {String responseJsonKey = "data"}) async {
    try {
      if (_accessToken.isEmpty) {
        _accessToken = await apiService.getAccessToken();
      }
      return await apiService.getEndpointData(
          accessToken: _accessToken,
          endpoint: endpoint,
          responseJsonKey: responseJsonKey);
    } on Response catch (e) {
      if (e.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await apiService.getEndpointData(
            accessToken: _accessToken, endpoint: endpoint);
      }
      rethrow;
    }
  }

  Future<EndpointsData> _getAllEndpointData() async {
    final values = await Future.wait([
      apiService.getEndpointData(
          accessToken: _accessToken,
          endpoint: Endpoint.cases,
          responseJsonKey: "cases"),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.casesSuspected),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.casesConfirmed),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.deaths),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.recovered),
    ]);

    return EndpointsData(values: {
      Endpoint.cases: values[0],
      Endpoint.casesSuspected: values[1],
      Endpoint.casesConfirmed: values[2],
      Endpoint.deaths: values[3],
      Endpoint.recovered: values[4],
    });
  }
}