import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:mqtttt/main.dart';
import 'package:mqtttt/models/subscription.dart' as models;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

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

  final _client = MqttServerClient('localhost', 'flutter_client');
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

    /// Set the correct MQTT protocol for mosquito
    _client.setProtocolV311();

    /// If you intend to use a keep alive you must set it here otherwise keep alive will be disabled.
    _client.keepAlivePeriod = 20;

    /// Add the unsolicited disconnection callback
    _client.onDisconnected = _onDisconnected;

    /// Add the successful connection callback
    _client.onConnected = _onConnected;

    /// Add a subscribed callback, there is also an unsubscribed callback if you need it.
    /// You can add these before connection or change them dynamically after connection if
    /// you wish. There is also an onSubscribeFail callback for failed subscriptions, these
    /// can fail either because you have tried to subscribe to an invalid topic or the broker
    /// rejects the subscribe request.
    _client.onSubscribed = onSubscribed;

    /// Set a ping received callback if needed, called whenever a ping response(pong) is received
    /// from the broker.
    // _client.pongCallback = pong;
    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    // _client.connectionMessage = connMess;
    try {
      await _client.connect();
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      print('MQTTHandler::client exception - $e');
      _client.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('MQTTHandler::socket exception - $e');
      _client.disconnect();
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

        notificationsPlugin
            .show(topicId, "Received MQTT message for topic ${element.topic}",
                message, null)
            .catchError((err) => print("error $err"));
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
