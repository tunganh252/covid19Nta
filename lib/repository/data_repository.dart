import 'package:covid19nta/repository/list_endpoints_data.dart';
import 'package:covid19nta/services/api.dart';
import 'package:covid19nta/services/api_service.dart';
import 'package:covid19nta/services/data_cache_service.dart';
import 'package:covid19nta/services/endpoint_data.dart';
import 'package:http/http.dart';

class DataRepository {
  DataRepository({required this.apiService, required this.dataCacheService});

  final APIService apiService;
  final DataCacheService dataCacheService;

  String _accessToken = "";

  Future<EndpointData> getDataEndpoint(Endpoint endpoint,
          {String responseJsonKey = "data"}) async =>
      await _getDataRefreshingToken<EndpointData>(
          onGetData: () => apiService.getEndpointData(
              accessToken: _accessToken,
              endpoint: endpoint,
              responseJsonKey: responseJsonKey));

  ListEndpointsData getAllEndpointCacheData() => dataCacheService.getData();

  Future<ListEndpointsData> getAllEndpointData() async {
    final dataGetAll = await _getDataRefreshingToken<ListEndpointsData>(
        onGetData: _getAllEndpointData);
    await dataCacheService.setData(dataGetAll);
    return dataGetAll;
  }

  Future<T> _getDataRefreshingToken<T>(
      {required Future<T> Function() onGetData}) async {
    try {
      if (_accessToken.isEmpty) {
        _accessToken = await apiService.getAccessToken();
      }
      return await onGetData();
    } on Response catch (e) {
      if (e.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await onGetData();
      }
      rethrow;
    }
  }

  Future<ListEndpointsData> _getAllEndpointData() async {
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

    return ListEndpointsData(values: {
      Endpoint.cases: values[0],
      Endpoint.casesSuspected: values[1],
      Endpoint.casesConfirmed: values[2],
      Endpoint.deaths: values[3],
      Endpoint.recovered: values[4],
    });
  }
}
