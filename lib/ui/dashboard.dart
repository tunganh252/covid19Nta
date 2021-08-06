import 'package:covid19nta/repository/data_repository.dart';
import 'package:covid19nta/services/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'enpoint_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _cases = 0;
  int _casesSuspected = 0;
  int _casesConfirmed = 0;
  int _deaths = 0;
  int _recovered = 0;

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    final cases = await dataRepository.getDataEndpoint(Endpoint.cases,
        responseJsonKey: "cases");
    final casesSuspected =
        await dataRepository.getDataEndpoint(Endpoint.casesSuspected);
    final casesConfirmed =
        await dataRepository.getDataEndpoint(Endpoint.casesConfirmed);
    final deaths = await dataRepository.getDataEndpoint(Endpoint.deaths);
    final recovered = await dataRepository.getDataEndpoint(Endpoint.recovered);
    setState(() {
      _cases = cases;
      _casesSuspected = casesSuspected;
      _casesConfirmed = casesConfirmed;
      _deaths = deaths;
      _recovered = recovered;
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
            EndpointCard(
              title: "Cases:",
              endpoint: Endpoint.cases,
              value: _cases,
            ),
            EndpointCard(
              title: "Suspected:",
              endpoint: Endpoint.casesSuspected,
              value: _casesSuspected,
            ),
            EndpointCard(
              title: "Confirmed:",
              endpoint: Endpoint.casesConfirmed,
              value: _casesConfirmed,
            ),
            EndpointCard(
              title: "Deaths:",
              endpoint: Endpoint.deaths,
              value: _deaths,
            ),
            EndpointCard(
              title: "Recovered",
              endpoint: Endpoint.recovered,
              value: _recovered,
            ),
          ],
        ),
      ),
    );
  }
}
