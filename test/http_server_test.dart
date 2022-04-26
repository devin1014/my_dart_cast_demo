// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

// NetworkInterface('lo0', [InternetAddress('127.0.0.1', IPv4)])
// NetworkInterface('en0', [InternetAddress('192.168.3.137', IPv4)])
// NetworkInterface('feth4265', [InternetAddress('192.168.192.39', IPv4)])

Future<void> main() async {
  print("server started");
  try {
    int index = 1;
    final server = await HttpServer.bind(InternetAddress.anyIPv4, 8083);
    await server.forEach((HttpRequest request) async {
      final uri = request.uri;
      if (uri.path == "/favicon.ico") return;
      print("--------");
      print("request: ${request.method} ${request.protocolVersion} ${request.uri}");
      print("headers:\n${request.headers.toString()}");
      final data = await utf8.decoder.bind(request).join();
      print("data:\n$data");
      print("\n");
      if (uri.path == "/byebye") {
        request.response
          ..write("byebye")
          ..close();
        server.close();
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
