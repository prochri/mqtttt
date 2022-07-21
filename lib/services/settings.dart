import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart'
    as screen_settings;
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// wrapper class around settings from flutter_settings_screens
class Settings {
  static SingleSetting<String> hostname = SingleSetting("mqtt-server-hostname", "localhost");
  static SingleSetting<String> username = SingleSetting("mqtt-server-username", "");
  static SingleSetting<String> password = SingleSetting("mqtt-server-password", "");

  static SingleSetting<String> devicePrefix = SingleSetting("device-prefix", "");

  static SingleSetting<bool> darkMode = SingleSetting("app-dark-mode", false);
}

void test(final Type t) {}

class SingleSetting<T> {
  final String settingKey;
  final T defaultValue;
  T get value {
    var v = screen_settings.Settings.getValue<T>(settingKey, defaultValue: defaultValue);
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

/// A cache access provider class for shared preferences using shared_preferences library.
///
/// This cache provider implementation is used by default, if non is provided explicitly.
class SharePreferenceCache extends CacheProvider {
  SharedPreferences? _preferences;

  @override
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _preferences = await SharedPreferences.getInstance();
  }

  Set get keys => getKeys();

  @override
  bool? getBool(String key, {bool? defaultValue}) {
    return _preferences?.getBool(key);
  }

  @override
  double? getDouble(String key, {double? defaultValue}) {
    return _preferences?.getDouble(key);
  }

  @override
  int? getInt(String key, {int? defaultValue}) {
    return _preferences?.getInt(key);
  }

  @override
  String? getString(String key, {String? defaultValue}) {
    return _preferences?.getString(key);
  }

  @override
  Future<void> setBool(String key, bool? value) async {
    await _preferences?.setBool(key, value ?? false);
  }

  @override
  Future<void> setDouble(String key, double? value) async {
    await _preferences?.setDouble(key, value!);
  }

  @override
  Future<void> setInt(String key, int? value) async {
    await _preferences?.setInt(key, value!);
  }

  @override
  Future<void> setString(String key, String? value) async {
    await _preferences?.setString(key, value!);
  }

  @override
  Future<void> setObject<T>(String key, T? value) async {
    if (T is int || value is int) {
      await _preferences?.setInt(key, value as int);
    } else if (T is double || value is double) {
      await _preferences?.setDouble(key, value as double);
    } else if (T is bool || value is bool) {
      await _preferences?.setBool(key, value as bool);
    } else if (T is String || value is String) {
      await _preferences?.setString(key, value as String);
    } else {
      throw Exception('No Implementation Found');
    }
  }

  @override
  bool containsKey(String key) {
    return _preferences?.containsKey(key) ?? false;
  }

  @override
  Set getKeys() {
    return _preferences?.getKeys() ?? {};
  }

  @override
  Future<void> remove(String key) async {
    if (containsKey(key)) {
      await _preferences?.remove(key);
    }
  }

  @override
  Future<void> removeAll() async {
    await _preferences?.clear();
  }

  @override
  T? getValue<T>(String key, {T? defaultValue}) {
    if (T is int || defaultValue is int) {
      return _preferences?.getInt(key) as T;
    }
    if (T is double || defaultValue is double) {
      return _preferences?.getDouble(key) as T;
    }
    if (T is bool || defaultValue is bool) {
      return _preferences?.getBool(key) as T;
    }
    if (T is String || defaultValue is String) {
      return _preferences?.getString(key) as T;
    }
    return _preferences?.get(key) as T;
  }
}

