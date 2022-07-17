import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart'
    hide Settings;

import '../services/settings.dart';
// import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsGroup(
          title: 'MQTT Server Settings',
          children: <Widget>[
            TextInputSettingsTile(
                title: "Server URL", settingKey: Settings.hostname.settingKey
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
          ],
        ),
        SettingsGroup(
          title: "App settings",
          children: [
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
        SettingsGroup(
          title: 'Device Settings',
          children: [
            TextInputSettingsTile(
              title: "Device Prefix",
              settingKey: Settings.devicePrefix.settingKey,
            )
          ],
        )
      ],
    );
  }
}
