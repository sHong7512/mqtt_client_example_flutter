import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:path_provider/path_provider.dart';
import 'mqtt_client_manager.dart';

// import 'package:mqtt5_client/mqtt5_client.dart';
// import 'mqtt5_client_manager.dart';

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
  Uint8List? _arrivedMemory;

  @override
  void initState() {
    setupMqttClient();

    super.initState();
  }

  Future<void> setupMqttClient() async {
    await mqttClientManager.connect();
    // mqttClientManager.subscribe("${TOP_TOPIC}");
    mqttClientManager.subscribe("${TOP_TOPIC}/#");
    // mqttClientManager.subscribe('${TOP_TOPIC}/+/aa');

    await mqttClientManager.setArrived((c) {
      final recMess = c[0].payload as MqttPublishMessage;
      if (c[0].topic == "$TOP_TOPIC/image") {
        _arrived = 'arrived : $TOP_TOPIC/image ${DateTime.now().toString()}';
        _arrivedMemory = recMess.payload.message.buffer.asUint8List();

        setState(() {});
      } else {
        final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message); //v3
        // final pt = MqttUtilities.bytesToStringAsString(recMess.payload.message!); //v5

        print('shong] Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
        _arrived = 'arrived : $pt ${DateTime.now().toString()}';
        setState(() {});
      }
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_arrivedMemory != null)
                          Image.memory(
                            _arrivedMemory!,
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                          ),
                        sendImageButton('${TOP_TOPIC}/image'),
                      ],
                    ),
                  ),
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

  ElevatedButton sendImageButton(String topic) => ElevatedButton(
        onPressed: () async {
          final file = await _selectFile();
          final bytes = await file?.readAsBytes();
          if (bytes == null) return;

          mqttClientManager.publishUnit8List(topic, bytes);
          setState(() {
            _send = 'send : ${file?.path}';
          });
        },
        child: Text('send-$topic'),
      );

  Future<File?> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  Future<void> _saveFile(Uint8List memory) async {
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/image.jpg').create();
    file.writeAsBytesSync(memory);
  }
}
