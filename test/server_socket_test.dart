import 'dart:convert';
import 'dart:io';

import '_test_util.dart';

const tag = "Socket";

void main() async {
  final serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 5678);
  Future.delayed(const Duration(seconds: 30), () async {
    await serverSocket.close();
  });
  await serverSocket.forEach((client) async {
    printLog(tag, "connected by: ${client.address.address} ${client.port}");
    String request = "";
    request = await utf8.decoder.bind(client).join();
    client.write("response:ok");
    client.close();
  });
}
