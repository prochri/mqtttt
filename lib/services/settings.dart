import 'dart:io';

import 'package:flutter_settings_screens/flutter_settings_screens.dart'
    as screen_settings;

/// wrapper class around settings from flutter_settings_screens
class Settings {
  static SingleSetting<String> hostname = SingleSetting("mqtt-server-hostname", "localhost");
  static SingleSetting<String?> username = SingleSetting.nullable("mqtt-server-username");
  static SingleSetting<String?> password = SingleSetting.nullable("mqtt-server-password");

  static SingleSetting<bool> darkMode = SingleSetting("app-dark-mode", false);
}

void test(final Type t) {}

class SingleSetting<T> {
  final String settingKey;
  final T defaultValue;
  T get value {
    var v = screen_settings.Settings.getValue<T>(settingKey);
    if (v == null) {
      value = defaultValue;
    }
    return v!;
  }

  set value(T? v) {
    screen_settings.Settings.setValue(settingKey, value);
  }

  SingleSetting(this.settingKey, this.defaultValue) {}
  static SingleSetting<T?> nullable<T>(settingsKey) {
    return SingleSetting<T?>(settingsKey, null);
  }
}

class NullableSingleSetting<T> extends SingleSetting<T?> {
  NullableSingleSetting(settingsKey) : super(settingsKey, null);
}
