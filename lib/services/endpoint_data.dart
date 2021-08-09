class EndpointData {
  EndpointData({required this.value, required this.dateTime})
      // ignore: unnecessary_null_comparison
      : assert(value != null);
  final int value;
  final DateTime? dateTime;
}
