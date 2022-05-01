import 'dart:async';
import 'dart:io';

import '_test_util.dart';

const tag = "Socket";

void main() async {
  // _connectBaidu()
  final socket = await _startClient();
  Timer.periodic(const Duration(seconds: 1), (timer) {
    socket.write("msg:${timer.tick}");
    if (timer.tick == 30) {
      socket.write("byebye");
      socket.close();
      socket.destroy();
    }
  });
  await Future.delayed(const Duration(seconds: 30), () {
    socket.write("byebye");
    socket.close();
    socket.destroy();
  });
}

Future<Socket> _startClient() async {
  final socket = await Socket.connect(InternetAddress.loopbackIPv4, 5678);
  socket.listen(
    (event) {
      printLog(tag, String.fromCharCodes(event).trim());
    },
    onDone: () {
      printLog(tag, "onDone");
    },
    onError: (e) {
      printLog(tag, e.toString());
      socket.close();
    },
  );
  return socket;
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
