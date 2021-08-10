import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LastUpdatedDateFormatter {
  LastUpdatedDateFormatter({required this.lastUpdate});
  final DateTime? lastUpdate;

  String lastUpdateStatusText() {
    // ignore: unnecessary_null_comparison
    if (lastUpdate != null) {
      final formatter = DateFormat.yMd().add_Hms();
      final formatted = formatter.format(lastUpdate!);

      return 'Last updated: $formatted';
    }
    return "";
  }
}

class LastUpdateStatusText extends StatelessWidget {
  const LastUpdateStatusText({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
