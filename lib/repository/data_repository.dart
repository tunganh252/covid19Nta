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
}
