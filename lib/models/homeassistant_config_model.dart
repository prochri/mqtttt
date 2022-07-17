// ignore_for_file: constant_identifier_names

enum Component {
  alarm_control_panel,
  binary_sensor,
  button,
  camera,
  cover,
  device_tracker,
  device_trigger,
  fan,
  humidifier,
  climate,
  light,
  lock,
  number,
  scene,
  select,
  sensor,
  siren,
  zwitch,
  tag_scanner,
  vacuum,
}

extension ComponentHAName on Component {
  String get homeAssistantName {
    return this == Component.zwitch ? "switch" : name;
  }
}

abstract class HomeAssistantDiscoveryConfiguration {
  final Component component;

  HomeAssistantDiscoveryConfiguration({
    required this.component,
  });

  String get payload;
}
