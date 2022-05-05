// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import '../util.dart';

class LocalHttpServer {
  static const tag = "LocalHttpServer";

  LocalHttpServer({int port = 0}) : _port = port;

  HttpServer? _httpServer;

  final int _port;

  bool get isRunning => _httpServer != null;

  String getBaseUrl() => isRunning ? "http://${_httpServer!.address.address}:${_httpServer!.port}" : "";

  Future<void> start(void Function(HttpRequest request) onRequest) async {
    if (_httpServer != null) return;
    printLog(tag, "server is starting");
    final networkInterface = await _getLocalInternetIp();
    _httpServer = await HttpServer.bind(networkInterface.addresses.first, _port);
    printLog(tag, "server is started, ${_httpServer!.address.address}:${_httpServer!.port}");
    _httpServer!.forEach((HttpRequest request) async {
      final uri = request.uri;
      if (uri.path == "/favicon.ico") {
        request.response.close();
        return;
      }
      if (request.connectionInfo != null) {
        printLog(tag, "connected: ${request.connectionInfo!.remoteAddress}");
      }
      printLog(tag, "request: ${request.method} ${request.protocolVersion} ${request.uri}");
      printLog(tag, "headers: ${request.headers.toString()}");
      if (request.contentLength > 0) {
        final data = await utf8.decoder.bind(request).join();
        printLog(tag, "content: $data");
      }
      onRequest(request);
      final response = request.response;
      response.close();
    });
  }

  Future<void> stop() async {
    printLog(tag, "server is closing");
    await _httpServer?.close();
    printLog(tag, "server is closed");
    _httpServer = null;
  }

  Future<NetworkInterface> _getLocalInternetIp() async =>
      (await NetworkInterface.list(type: InternetAddress.anyIPv4.type)).first;
}
