import 'package:flutter/material.dart';

import 'mqtt_client_page.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'MQTT Client Example',
      home: MQTTClientPage(),
    ),
  );
}
