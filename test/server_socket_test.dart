import 'dart:io';

import '_test_util.dart';

const tag = "Socket";

final clientList = <Socket>[];
ServerSocket? _serverSocket;

void main() async {
  _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 5678);
  await _serverSocket!.forEach((client) {
    printLog(tag, "connected from: ${client.remoteAddress.address} ${client.remotePort}");
    _processClient(client);
    _notifyClient("welcome client(${client.remoteAddress}:${client.remotePort})", client);
  });
}

void _processClient(Socket client) {
  clientList.add(client);
  client.listen((data) async {
    final msg = String.fromCharCodes(data).trim();
    printLog(tag, msg);
    client.write("ok");
    _notifyClient(msg, client);
    if (msg == "byebye") {
      clientList.remove(client);
      if (clientList.isEmpty) {
        await _serverSocket?.close();
      }
    }
  });
}

void _notifyClient(String msg, Socket source) {
  for (var element in clientList) {
    if (element != source) {
      element.write(msg);
    }
  }
}
