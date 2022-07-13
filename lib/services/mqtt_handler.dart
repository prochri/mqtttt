import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:mqtttt/main.dart';
import 'package:mqtttt/models/subscription.dart' as models;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'settings.dart';

// see https://github.com/shamblett/mqtt_client/tree/master/example for examples
class MQTTHandler {
  static MQTTHandler _instance = MQTTHandler();
  static MQTTHandler get instance {
    return _instance;
  }

  // for debugging
  static recreateInstance() {
    print('recreate MQTTHandler');
    _instance = MQTTHandler();
    _instance.connect();
  }

  final _client = MqttServerClient('192.168.178.100', 'flutter_client');
  bool _connected = false;
  bool get connected {
    return _connected;
  }

  List<models.Subscription> _subscriptions = [];
  List<models.Subscription> get subscriptions {
    return _subscriptions;
  }

  MQTTHandler() {}

  void restart() {
    print("restarting");
    _client.disconnect();
    connect();
  }

  void addSubscription(models.Subscription subscription) {
    Subscription? s =
        _client.subscribe(subscription.topic, MqttQos.exactlyOnce);
    subscriptions.add(subscription);
  }

  void connect() async {
    _client.logging(on: true);
    _client.setProtocolV311();
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;
    _client.onSubscribed = onSubscribed;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('client')
        .startClean() // Non persistent session for testing
        .authenticateAs(Settings.username.value, Settings.password.value);
    _client.connectionMessage = connMess;
    try {
      await _client.connect();
      print("sucessfull conection ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      print("unsucessfull conection !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      print('MQTTHandler::client exception - $e');
      _client.disconnect();
      return;
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('MQTTHandler::socket exception - $e');
      _client.disconnect();
      return;
    }

    _client.updates!.listen((messageList) {
      print("received ${messageList.length}");
      messageList.forEach((element) {
        final msg = element.payload;
        if (msg is! MqttPublishMessage) return;
        final message =
            MqttPublishPayload.bytesToStringAsString(msg.payload.message);
        var topicId = _client.subscriptionsManager!
            .subscriptions[element.topic]!.messageIdentifier!;

        if (!Platform.isWindows) {
          notificationsPlugin
              .show(topicId, "Received MQTT message for topic ${element.topic}",
                  message, null)
              .catchError((err) => print("error $err"));
        }
        print("${element.topic}, $topicId, ${message}");
      });
    });
    addSubscription(models.Subscription("a/b"));

    final builder = MqttClientPayloadBuilder();
    builder.addString("hello from flutter");
    _client.publishMessage("a/b", MqttQos.exactlyOnce, builder.payload!);
  }

  // callback examples

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('MQTTHandler::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void _onDisconnected() {
    _connected = false;
    print('MQTTHandler::OnDisconnected client callback - Client disconnection');
    if (_client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print(
          'MQTTHandler::OnDisconnected callback is solicited, this is correct');
    } else {
      print(
          'MQTTHandler::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
    }
  }

  /// The successful connect callback
  void _onConnected() {
    _connected = true;
    print(
        'MQTTHandler::OnConnected client callback - Client connection was successful');
  }

  /// Pong callback
  void pong() {
    print('MQTTHandler::Ping response client callback invoked');
  }
}
