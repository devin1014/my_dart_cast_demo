// ignore_for_file: constant_identifier_names, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '_test_util.dart';

void main() async {
  _startUDPServer();
  _startUDPClient();
  await Future.delayed(const Duration(seconds: 30), () {});
}

const _serverPort = 8083;
const _clientPort = 8084;

void _startUDPServer() async {
  const tag = "UDPServer";
  final RawDatagramSocket rawDatagramSocket = await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, _serverPort);
  await for (RawSocketEvent event in rawDatagramSocket) {
    if (event == RawSocketEvent.read) {
      final data = utf8.decode(rawDatagramSocket.receive()!.data);
      printLog(tag, "receive: $data");
      rawDatagramSocket.send(utf8.encode(DateTime.now().toString()), InternetAddress.loopbackIPv4, _clientPort);
      if (data == "byebye") {
        rawDatagramSocket.close();
      }
    }
  }
}

void _startUDPClient() async {
  const tag = "UDPClient";
  final RawDatagramSocket rawDatagramSocket = await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, _clientPort);
  Timer.periodic(const Duration(seconds: 2), (timer) {
    if (timer.tick > 5) {
      rawDatagramSocket.close();
    } else if (timer.tick == 5) {
      rawDatagramSocket.send(utf8.encode("byebye"), InternetAddress.loopbackIPv4, _serverPort);
    } else {
      rawDatagramSocket.send(utf8.encode("hi ${timer.tick}"), InternetAddress.loopbackIPv4, _serverPort);
    }
  });
  await for (RawSocketEvent event in rawDatagramSocket) {
    if (event == RawSocketEvent.read) {
      final data = utf8.decode(rawDatagramSocket.receive()!.data);
      printLog(tag, "receive: $data");
    }
  }
}
