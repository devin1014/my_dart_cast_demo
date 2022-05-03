// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import '_test_util.dart';

// NetworkInterface('lo0', [InternetAddress('127.0.0.1', IPv4)])
// NetworkInterface('en0', [InternetAddress('192.168.3.137', IPv4)])
// NetworkInterface('feth4265', [InternetAddress('192.168.192.39', IPv4)])

Future<void> main() async {
  print("server started");
  final deeplinkHtml = await File("resources/html/deeplink.html").readAsString();
  try {
    int index = 1;
    final networkInterface = await _getLocalInternetIp();
    final server = await HttpServer.bind(networkInterface.addresses.first, 8083);
    printLog("HttpServer", "started: ${server.address.address}:${server.port}");
    await server.forEach((HttpRequest request) async {
      final uri = request.uri;
      if (uri.path == "/favicon.ico") return;
      print("\n");
      print("request: ${request.method} ${request.protocolVersion} ${request.uri}");
      print("headers:\n${request.headers.toString()}");
      final data = await utf8.decoder.bind(request).join();
      if (data.isNotEmpty) {
        print("data:\n$data");
      }
      print("\n");
      if (uri.path == "/byebye") {
        request.response
          ..write("byebye")
          ..close();
        server.close();
      } else if (uri.path == "/deeplink") {
        request.response.headers.add("Content-Type", "text/html");
        request.response
          ..write(deeplinkHtml)
          ..close();
      } else {
        request.response
          ..write('OK\n$data\n${index++}')
          ..close();
      }
    });
  } catch (e) {
    print(e.toString());
  }
  print("server stopped");
}

Future<NetworkInterface> _getLocalInternetIp() async =>
    (await NetworkInterface.list(type: InternetAddress.anyIPv4.type)).first;
