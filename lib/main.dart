import 'dart:io';

import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:mqtttt/base_scaffold.dart';
import 'package:mqtttt/pages/settings_page.dart';
import 'package:mqtttt/services/mqtt_handler.dart';
import 'package:mqtttt/pages/mqtt_test_screen.dart';
import 'package:system_tray/system_tray.dart';
import 'package:mqtttt/pages/subscribe_page.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('app_icon');
  var linuxSettings =
      LinuxInitializationSettings(defaultActionName: 'mqtt testing tool');
  var initialization = InitializationSettings(linux: linuxSettings);
  await notificationsPlugin.initialize(initialization,
      onSelectNotification: (String? payload) {
    print("received $payload as payload");
  });
  await Settings.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _systemTray = SystemTray();
  final _appWindow = AppWindow();

  @override
  void initState() {
    super.initState();
    initSystemTray();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: BaseScaffold(
        pages: [
          BaseScaffoldPage('Home Page', Icons.home, const MyHomePage()),
          BaseScaffoldPage('Subscribe', Icons.home, SubscribePage()),
          BaseScaffoldPage('MQTT test', Icons.settings, MQTTTest()),
          BaseScaffoldPage('Settings', Icons.settings, SettingsPage()),
        ],
      ),
    );
  }

  Future<void> initSystemTray() async {
    String path =
        Platform.isWindows ? 'assets/app_icon.ico' : 'assets/app_icon.png';

    final menu = [
      MenuItem(label: 'Show', onClicked: _appWindow.show),
      MenuItem(label: 'Hide', onClicked: _appWindow.hide),
      MenuItem(label: 'Exit', onClicked: _appWindow.close),
    ];

    // We first init the systray menu and then add the menu entries
    await _systemTray.initSystemTray(
      title: "system tray",
      iconPath: path,
    );

    await _systemTray.setContextMenu(menu);

    // handle system tray event
    _systemTray.registerSystemTrayEventHandler((eventName) {
      debugPrint("eventName: $eventName");
      if (eventName == "leftMouseDown") {
      } else if (eventName == "leftMouseUp") {
        _systemTray.popUpContextMenu();
      } else if (eventName == "rightMouseDown") {
      } else if (eventName == "rightMouseUp") {
        _appWindow.show();
      }
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        children: [
          Text('hello world'),
          TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/test');
              },
              child: Text('test')),
        ],
      ),
    );
  }
}
