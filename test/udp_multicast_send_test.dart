// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '_test_util.dart';

const String _SEARCH_MESSAGE = """M-SEARCH * HTTP/1.1\r
HOST: 239.255.255.250:1900\r
ST: ssdp:all\r
MAN: "ssdp:discover"\r
MX: 3\r\n\r\n""";

const _NOTIFY_MESSAGE = """NOTIFY * HTTP/1.1\r
HOST: 239.255.255.250:1900\r
CACHE-CONTROL: max-age=66\r
LOCATION: http://192.168.3.119:49152/description.xml\r
NT: uuid:F7CA5454-3F48-4390-8009-403e48ef451f\r
NTS: ssdp:alive\r
SERVER: Linux/3.10.61+, UPnP/1.0, Portable SDK for UPnP devices/1.6.13\r
USN: uuid:F7CA5454-3F48-4390-8009-403e48ef451f\r\n\r\n""";

void main() async {
  final multicastAddress = InternetAddress("239.255.255.250");
  const multicastPort = 1900;
  const sendNotify = true;
  final message = sendNotify ? _NOTIFY_MESSAGE : _SEARCH_MESSAGE;

  final messageSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
  messageSocket.broadcastEnabled = true;
  messageSocket.listen((event) {
    if (event == RawSocketEvent.read) {
      var message = utf8.decode(messageSocket.receive()!.data);
      printLog("message", "receive:\n$message");
    } else if (event == RawSocketEvent.write) {
      messageSocket.send(utf8.encode(message), multicastAddress, multicastPort);
    }
  });

  final timer = Timer.periodic(const Duration(seconds: 10), (timer) {
    printLog("message", "notify...");
    messageSocket.send(utf8.encode(message), multicastAddress, multicastPort);
  });
  await Future.delayed(const Duration(seconds: 60), () {
    timer.cancel();
    messageSocket.close();
  });
}
