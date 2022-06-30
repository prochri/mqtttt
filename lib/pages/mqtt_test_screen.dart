import 'package:flutter/material.dart';
import 'package:mqtttt/mqtt/mqtt_handler.dart';

class MQTTTest extends StatefulWidget {
  MQTTTest({Key? key}) : super(key: key);

  @override
  State<MQTTTest> createState() => _MQTTTestState();
}

class _MQTTTestState extends State<MQTTTest> {
  MQTTHandler? _mqtt;

  void _reloadMqtt() {
    _mqtt = MQTTHandler();
    _mqtt?.connect();
  }

  @override
  Widget build(BuildContext context) {
    // _reloadMqtt();
    return Column(
      children: [
        TextButton(
          onPressed: () {_reloadMqtt();},
          child: Text('reload MQTT handler'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
          child: Text('push home page'),
        ),
      ],
    );
  }
}
