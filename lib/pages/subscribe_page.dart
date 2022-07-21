import 'package:flutter/material.dart';
import 'package:mqtttt/models/subscription.dart';
import 'package:mqtttt/services/mqtt_handler.dart';
import 'package:mqtttt/widgets/add_subscription.dart';

import '../models/topic_handler.dart';

class SubscribePage extends StatefulWidget {
  SubscribePage({Key? key}) : super(key: key);

  @override
  State<SubscribePage> createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  String? topic;
  late MQTTHandler _mqttHandler;

  @override
  void initState() {
    _mqttHandler = MQTTHandler.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building with ${topic}');
    var topicField = TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'topic',
      ),
      onChanged: (text) {
        topic = text;
        print('topic $topic');
      },
    );
    return Column(children: [
      Text('hello'),
      topicField,
      TextButton(onPressed: _addSubscription, child: const Text("add new subscription")),
      const Text("current Subscriptions:"),
      Container(
        height: 800,
        child: ListView.separated(
          itemCount: _mqttHandler.subscriptions.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            _mqttHandler.subscriptions[index].toString();
            return Text("hi");
            // return Text(
            //     "${_mqttHandler.subscriptions.length} ${_mqttHandler.subscriptions[index].topic} ${_mqttHandler.connected}");
          },
        ),
      )
    ]);
  }

  void _addSubscription() async {
    var topic = await showDialog<String?>(
        context: context, builder: (context) => const AddSubscription());
    if (topic == null) return;
    setState(() {
      _mqttHandler.registerTopic(topic, TopicHandler());
    });
  }
}
