import 'package:covid19nta/repository/data_repository.dart';
import 'package:covid19nta/repository/list_endpoints_data.dart';
import 'package:covid19nta/services/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'enpoint_card.dart';
import 'last_update_status_text.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ListEndpointsData? _listEndpointsData;

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    final endpointsData = await dataRepository.getAllEndpointData();

    setState(() {
      _listEndpointsData = endpointsData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Coronavirus Tracker"),
      ),
      body: RefreshIndicator(
        onRefresh: () => _update(),
        child: ListView(
          children: [
            LastUpdateStatusText(
              text: _listEndpointsData != null
                  ? _listEndpointsData!.values[Endpoint.cases]!.dateTime
                          ?.toString() ??
                      ''
                  : "hello",
            ),
            for (var endpoint in Endpoint.values)
              EndpointCard(
                endpoint: endpoint,
                // ignore: unnecessary_null_comparison
                value: _listEndpointsData != null
                    ? _listEndpointsData!.values[endpoint]!.value
                    : 0,
              ),
          ],
        ),
      ),
    );
  }
}
