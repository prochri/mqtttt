import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' hide Settings;

import '../services/settings.dart';
// import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Text("hello");
    // return SettingsList(
    //   sections: [
    //     SettingsSection(title: Text("mqtt settings"), tiles: [
    //       SettingsTile.switchTile(
    //           initialValue: true, onToggle: (value) {}, title: Text("hello"))
    //     ])
    //   ],
    // );
    return Container(
      alignment: Alignment.topCenter,
      child: SettingsGroup(
        title: 'MQTT Server Settings',
        children: <Widget>[
          TextInputSettingsTile(
            title: "Server URL",
            settingKey: Settings.hostname.settingKey
            // leading: Icon(Icons.home_work_outlined),
          ),
          TextInputSettingsTile(
            title: "Username",
            settingKey: Settings.username.settingKey,
            // leading: Icon(Icons.home_work_outlined),
          ),
          TextInputSettingsTile(
            title: "Password",
            settingKey: Settings.password.settingKey,
            obscureText: true,
            // leading: Icon(Icons.home_work_outlined),
          ),
          SimpleSettingsTile(
            title: 'Advanced',
            subtitle: 'More, advanced settings.',
            child: SettingsScreen(
              title: 'Sub menu',
              children: <Widget>[Text("currently no advanced settings")],
            ),
          ),
          CheckboxSettingsTile(
            settingKey: 'key-day-light-savings',
            title: 'Daylight Time Saving',
            enabledLabel: 'Enabled',
            disabledLabel: 'Disabled',
            leading: Icon(Icons.timelapse),
          ),
          SwitchSettingsTile(
            settingKey: Settings.darkMode.settingKey,
            title: 'Dark Mode',
            enabledLabel: 'Enabled',
            disabledLabel: 'Disabled',
            leading: Icon(Icons.palette),
          ),
        ],
      ),
    );
  }
}
