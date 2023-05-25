import 'package:flutter/material.dart';
// import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'mqtt5_client_manager.dart';
import 'mqtt_client_manager.dart';

class MQTTClientPage extends StatefulWidget {
  const MQTTClientPage({super.key});

  @override
  State<MQTTClientPage> createState() => _MQTTClientPageState();
}

class _MQTTClientPageState extends State<MQTTClientPage> {
  MQTTClientManager mqttClientManager = MQTTClientManager(primaryId: '${DateTime.now()}');
  // MQTT5ClientManager mqttClientManager = MQTT5ClientManager(primaryId: '${DateTime.now()}');

  String _arrived = 'arrived : ';
  String _send = 'send : ';

  @override
  void initState() {
    setupMqttClient();

    super.initState();
  }

  Future<void> setupMqttClient() async {
    await mqttClientManager.connect();
    // mqttClientManager.subscribe("${TOP_TOPIC}");
    // mqttClientManager.subscribe("${TOP_TOPIC}/#");
    mqttClientManager.subscribe('${TOP_TOPIC}/+/aa');

    await mqttClientManager.setArrived((c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message); //v3
      // final pt = MqttUtilities.bytesToStringAsString(recMess.payload.message!); //v5
      print('shong] Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      setState(() {
        _arrived = 'arrived : $pt ${DateTime.now().toString()}';
      });
    });
  }

  @override
  void dispose() {
    mqttClientManager.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(_arrived),
              Text(_send),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  sendButton('${TOP_TOPIC}'),
                  sendButton('${TOP_TOPIC}/a'),
                  sendButton('${TOP_TOPIC}/a/aa'),
                  sendButton('${TOP_TOPIC}/a/bb'),
                  sendButton('${TOP_TOPIC}/b'),
                  sendButton('${TOP_TOPIC}/b/aa'),
                  sendButton('${TOP_TOPIC}/test/a/aa'),
                  sendButton('${TOP_TOPIC}/test/b/aa'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton sendButton(String topic) => ElevatedButton(
        onPressed: () {
          String msg = 'I\'m flutter - $topic';
          mqttClientManager.publishMessage(topic, msg);
          setState(() {
            _send = 'send : $msg';
          });
        },
        child: Text('send-$topic'),
      );
}
