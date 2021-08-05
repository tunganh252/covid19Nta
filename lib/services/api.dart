import 'package:covid19nta/services/api_keys.dart';

class API {
  API({required this.apiKey});
  final String apiKey;

  factory API.sandox() => API(apiKey: APIKeys.sandBoxKey);

  static final String host = "ncov2019-admin.firebaseapp.com";

  Uri tokenUri() => Uri(scheme: "https", host: host, path: 'token');
}
