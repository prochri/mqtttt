import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:mqtttt/main.dart';
import 'package:mqtttt/models/subscription.dart' as models;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtttt/models/topic_handler.dart';

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
    print('recreate MQTTHandler');
    _instance.connect();
  }

  final _client;
  bool _connected = false;
  bool get connected {
    return _connected;
  }

  List<String> _subscriptions = [];
  List<String> get subscriptions {
    return _subscriptions;
  }

  Map<String, TopicHandler> topicHandler = {};

  MQTTHandler()
      : _client = MqttServerClient(Settings.hostname.value, 'flutter_client');

  void restart() {
    print("restarting");
    _client.disconnect();
    connect();
  }

  void registerTopic(String topic, TopicHandler topicHandler) {
    Subscription? s = _client.subscribe(topic, MqttQos.exactlyOnce);
    print("${s?.messageIdentifier} $s ##################################3");
    subscriptions.add(topic);
    this.topicHandler[topic] = topicHandler;
  }

  Future<void> connect() async {
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
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
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
      messageList.forEach(messageHandler);
    });

    final builder = MqttClientPayloadBuilder();
    builder.addString("hello from flutter");
    _client.publishMessage("a/b", MqttQos.exactlyOnce, builder.payload!);
  }

  void messageHandler(MqttReceivedMessage<MqttMessage> receivedMessage) {
    final msg = receivedMessage.payload;
    if (msg is! MqttPublishMessage) return;
    final messageContent = msg.payload.message;
    topicHandler[receivedMessage.topic]?.call(messageContent);
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
