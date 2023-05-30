// import 'dart:async';
// import 'dart:io';
// import 'package:mqtt5_client/mqtt5_client.dart';
// import 'package:mqtt5_client/mqtt5_server_client.dart';
// import 'package:typed_data/typed_buffers.dart';
//
// const String SERVER_IP = '192.168.2.133';
// const int SERVER_PORT = 1883;
// const String TOP_TOPIC = 'topic';
//
/**
 * MQTT v5
 */
// class MQTT5ClientManager {
//   MQTT5ClientManager({required this.primaryId}){
//     client = MqttServerClient.withPort(SERVER_IP, primaryId, SERVER_PORT);
//   }
//   final String primaryId;
//
//   late MqttServerClient client;
//
//   StreamSubscription? _arrivedStream;
//   StreamSubscription? _publishedStream;
//
//   Future<int> connect() async {
//     client.logging(on: false);
//     // client.keepAlivePeriod = 60;
//     client.onDisconnected = onDisconnected;
//     client.onConnected = onConnected;
//     client.onSubscribed = onSubscribed;
//     client.pongCallback = pong;
//
//     // final property = MqttUserProperty();
//     // property.pairName = 'Example name';
//     // property.pairValue = 'Example value';
//     final connMess = MqttConnectMessage()
//         // .withClientIdentifier('MQTT5DartClient')
//         .startClean(); // Or startSession() for a persistent session
//         // .withUserProperties([property]);
//     client.connectionMessage = connMess;
//
//     try {
//       await client.connect();
//     } on MqttNoConnectionException catch (e) {
//       // Raised by the client when connection fails.
//       print('shong] client exception - $e');
//       client.disconnect();
//     } on SocketException catch (e) {
//       // Raised by the socket layer
//       print('shong] socket exception - $e');
//       client.disconnect();
//     }
//
//     if (client.connectionStatus!.state == MqttConnectionState.connected) {
//       print(
//           'shong] Mqtt5 server client connected, return code is ${client.connectionStatus!.reasonCode.toString().split('.')[1]}');
//       if (client.connectionStatus!.connectAckMessage.userProperty!.isNotEmpty) {
//         print(
//             'shong] Connected - user property name - ${client.connectionStatus!.connectAckMessage.userProperty![0].pairName}');
//         print(
//             'shong] Connected - user property value - ${client.connectionStatus!.connectAckMessage.userProperty![0].pairValue}');
//       }
//     } else {
//       print('shong] ERROR Mqtt5 client connection failed - status is ${client.connectionStatus}');
//       client.disconnect();
//       exit(-1);
//     }
//
//     return 0;
//   }
//
//   Future<void> setArrived(Function(List<MqttReceivedMessage<MqttMessage>>) onArrived) async {
//     await _arrivedStream?.cancel();
//     _arrivedStream = client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
//       print('shong] Change<Sub> notification:: list Size = ${c.length}');
//       onArrived.call(c);
//     });
//   }
//
//   Future<void> setPublished() async {
//     await _publishedStream?.cancel();
//     _publishedStream = client.published!.listen((MqttPublishMessage message) {
//       print('shong] Published notification:: topic = ${message.variableHeader!.topicName}, Qos = ${message.header!.qos}');
//     });
//   }
//
//   void subscribe(String topic) {
//     client.subscribe(topic, MqttQos.atLeastOnce);
//   }
//
//   void unSubscribe(String topic) {
//     client.unsubscribeStringTopic(topic);
//   }
//
//   void publishMessage(String topic, String message) {
//     final builder = MqttPayloadBuilder();
//     builder.addString(message);
//     client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
//   }
//
//   void publishUnit8List(String topic, Uint8List unit8List) {
//     Uint8Buffer dataBuffer = Uint8Buffer();
//     dataBuffer.addAll(unit8List);
//     client.publishMessage(topic, MqttQos.exactlyOnce, dataBuffer);
//   }
//
//   void disconnect() {
//     _arrivedStream?.cancel();
//     _publishedStream?.cancel();
//     client.disconnect();
//   }
//
//   Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
//     return client.updates;
//   }
//
//   void onSubscribed(MqttSubscription subscription) {
//     print('shong] Subscription confirmed for topic :: ${subscription.topic.rawTopic}');
//   }
//
//   void onDisconnected() {
//     print('shong] OnDisconnected client callback - Client disconnection');
//     if (client.connectionStatus!.disconnectionOrigin == MqttDisconnectionOrigin.solicited) {
//       print('shong] OnDisconnected callback is solicited');
//     }
//     // exit(0);
//   }
//
//   void onConnected() {
//     print('shong] OnConnected client callback - Client connection was successful');
//   }
//
//   void pong() {
//     print('shong] Ping response client callback invoked');
//   }
// }
