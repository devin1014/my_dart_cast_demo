import 'dart:io';

import '_test_util.dart';

const tag = "Socket";

void main() async {
  // _connectBaidu()
  final client = await _startClient();
  await Future.delayed(const Duration(seconds: 15), () {
    client.close();
  });
}

void _connectBaidu() async {
  String getMessage = 'GET / HTTP/1.1\nConnection: close\n\n';
  final socket = await Socket.connect("www.baidu.com", 80);
  printLog(tag, "connect to 'www.baidu.com'");
  printLog(tag, "${socket.address}:${socket.port}");
  printLog(tag, "${socket.remoteAddress}:${socket.remotePort}");
  socket.listen((event) {
    printLog(tag, String.fromCharCodes(event).trim());
  }, onDone: () {
    printLog(tag, "onDone");
    socket.close();
  });
  socket.write(getMessage);
}

Future<Socket> _startClient() async {
  final socket = await Socket.connect(InternetAddress.loopbackIPv4, 5678);
  socket.listen((event) {
    printLog(tag, String.fromCharCodes(event).trim());
  }, onDone: () {
    printLog(tag, "onDone");
    socket.close();
  });
  socket.write("hello");
  return socket;
}
