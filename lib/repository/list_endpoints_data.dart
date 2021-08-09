import 'package:covid19nta/services/api.dart';
import 'package:covid19nta/services/endpoint_data.dart';

class ListEndpointsData {
  ListEndpointsData({required this.values});
  final Map<Endpoint, EndpointData> values;

  EndpointData? get cases => values[Endpoint.cases];
  EndpointData? get casesSuspected => values[Endpoint.casesSuspected];
  EndpointData? get casesConfirmed => values[Endpoint.casesConfirmed];
  EndpointData? get deaths => values[Endpoint.deaths];
  EndpointData? get recovered => values[Endpoint.recovered];

  @override
  String toString() =>
      "cases: $cases casesSuspected: $casesSuspected casesConfirmed: $casesConfirmed deaths: $deaths recovered: $recovered";
}
