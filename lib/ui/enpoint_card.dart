import 'package:covid19nta/services/api.dart';
import 'package:flutter/material.dart';

class EndpointCard extends StatelessWidget {
  const EndpointCard(
      {Key? key,
      required this.title,
      required this.endpoint,
      required this.value})
      : super(key: key);

  final Endpoint endpoint;
  final int value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$title",
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                value > 0 ? value.toString() : '',
                style: Theme.of(context).textTheme.headline5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
