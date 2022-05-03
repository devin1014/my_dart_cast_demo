// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:my_dart_cast_demo/src/virtual_device/virtual_device.dart';

class MyLocalHttpServer {
  MyLocalHttpServer({int port = 0}) : _port = port;

  HttpServer? _httpServer;
  String _description = "";
  int _descriptionLength = 0;
  int _port;

  bool get isRunning => _httpServer != null;

  String get address {
    final value = _httpServer?.address.address;
    if (value == null) return "";
    if (value == InternetAddress.anyIPv4.address) return "localhost";
    return value;
  }

  int get port => _port;

  void bindDeviceBuilder(VirtualDeviceBuilder builder) {
    builder.host = address;
    builder.port = port;
    _description = builder.description;
    _descriptionLength = utf8.encode(_description).length;
  }

  Future<int> start() async {
    if (_httpServer != null) return _httpServer!.port;
    print("server is starting");
    final networkInterface = await _getLocalInternetIp();
    _httpServer = await HttpServer.bind(networkInterface.addresses.first, _port);
    _port = _httpServer!.port;
    print("server is started, ${_httpServer!.address.address}:${_httpServer!.port}");
    _httpServer!.forEach((HttpRequest request) async {
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
    return _httpServer!.port;
  }

  Future<void> stop() async {
    print("server is closing");
    await _httpServer?.close();
    print("server is closed");
    _httpServer = null;
  }

  Future<NetworkInterface> _getLocalInternetIp() async =>
      (await NetworkInterface.list(type: InternetAddress.anyIPv4.type)).first;
}
