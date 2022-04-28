// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

class MyLocalHttpServer {
  MyLocalHttpServer();

  HttpServer? _httpServer;
  String _description = "";
  int _descriptionLength = 0;

  set description(String data) {
    _description = data;
    _descriptionLength = utf8.encode(data).length;
  }

  bool get isRunning => _httpServer != null;

  Future<void> start(int port) async {
    if (_httpServer != null) return;
    print("server is starting: $port");
    _httpServer = await HttpServer.bind(InternetAddress.anyIPv4, port);
    print("server is started");
    await _httpServer!.forEach((HttpRequest request) async {
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
      final response = request.response;
      if (uri.path == "/description.xml") {
        if (_description.isNotEmpty) {
          response.contentLength = _descriptionLength;
          response.write(_description);
        } else {
          response.statusCode = 404;
        }
      }
      response.close();
    });
  }

  Future<void> stop() async {
    print("server is closing");
    await _httpServer?.close();
    print("server is closed");
    _httpServer = null;
  }
}
