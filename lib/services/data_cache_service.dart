import 'package:covid19nta/repository/list_endpoints_data.dart';
import 'package:covid19nta/services/api.dart';
import 'package:covid19nta/services/endpoint_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataCacheService {
  DataCacheService({required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  static String endpointValueKey(Endpoint endpoint) => '$endpoint/value';
  static String endpointDateKey(Endpoint endpoint) => '$endpoint/date';

  ListEndpointsData getData() {
    Map<Endpoint, EndpointData> values = {};
    Endpoint.values.forEach((element) {
      final value = sharedPreferences.getInt(endpointValueKey(element));
      final dateString = sharedPreferences.getString(endpointDateKey(element));
      if (value != null && dateString != null) {
        final date = DateTime.tryParse(dateString);
        values[element] = EndpointData(value: value, dateTime: date);
      }
    });
    return ListEndpointsData(values: values);
  }

  Future<void> setData(ListEndpointsData listEndpointsData) async {
    listEndpointsData.values.forEach((key, item) async {
      await sharedPreferences.setInt(endpointValueKey(key), item.value);
      await sharedPreferences.setString(
          endpointDateKey(key), item.dateTime!.toIso8601String());
    });
  }
}
