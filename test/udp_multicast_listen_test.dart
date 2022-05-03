// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '_test_util.dart';

const String _SEARCH_MESSAGE = """M-SEARCH * HTTP/1.1\r
HOST: 239.255.255.250:1900\r
ST: ssdp:all\r
MAN: "ssdp:discover"\r;
MX: 3\r\n\r\n""";

void main() async {
  final multicastAddress = InternetAddress("239.255.255.250");
  const multicastPort = 1900;
  final multicastSocket = await RawDatagramSocket.bind(
    InternetAddress.anyIPv4,
    multicastPort,
    reuseAddress: true,
    reusePort: true,
    ttl: 255,
  );
  multicastSocket
    ..multicastLoopback = false
    ..multicastHops = 12
    ..joinMulticast(multicastAddress)
    ..listen((event) {
      if (event == RawSocketEvent.read) {
        var message = utf8.decode(multicastSocket.receive()!.data);
        printLog("multicast", "receive:\n$message");
      }
    });

  final messageSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
  messageSocket.listen((event) {
    if (event == RawSocketEvent.read) {
      var message = utf8.decode(messageSocket.receive()!.data);
      printLog("message", "receive:\n$message");
    }
  });

  final timer = Timer.periodic(const Duration(seconds: 15), (timer) {
    printLog("message", "search...");
    messageSocket.send(utf8.encode(_SEARCH_MESSAGE), multicastAddress, multicastPort);
  });

  await Future.delayed(const Duration(seconds: 60), () {
    timer.cancel();
    multicastSocket.close();
    messageSocket.close();
  });
}
