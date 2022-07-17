// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mqtttt/models/homeassistant_config_model.dart';
import 'package:mqtttt/models/topic_handler.dart';
import 'package:mqtttt/services/mqtt_handler.dart';

void main() async {
  await Settings.init();
  var mqtt = MQTTHandler.instance;
  await mqtt.connect();
  mqtt.addSubscription("a/b", TopicHandler());
  mqtt.addSubscription("a/b", TopicHandler());
}
