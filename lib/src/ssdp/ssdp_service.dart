// ignore_for_file: constant_identifier_names, avoid_print, prefer_adjacent_string_concatenation, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:my_dart_cast_demo/src/ssdp/upnp_message.dart';

typedef RawDatagramSocketFactory = Future<RawDatagramSocket> Function(
  dynamic host,
  int port, {
  bool reuseAddress,
  bool reusePort,
  int ttl,
});

typedef OnDataListener = Function(String data);

class SSDPService {
  static const String _UPNP_IP_V4 = '239.255.255.250';
  static const int _UPNP_PORT = 1900;

  static const String TYPE_DEVICE_ALL = "ssdp:all";
  static const String TYPE_DEVICE_ROOT = "upnp:rootdevice";
  static const String TYPE_DEVICE_MEDIA_RENDERER = "urn:schemas-upnp-org:device:MediaRenderer:1";
  static const String TYPE_SERVICE_AV_TRANSPORT = "urn:schemas-upnp-org:service:AVTransport:1";
  static const String TYPE_SERVICE_CONNECTION_MANAGER = "urn:schemas-upnp-org:service:ConnectionManager:1";
  static const String TYPE_SERVICE_RENDERING_CONTROL = "urn:schemas-upnp-org:service:RenderingControl:1";

  final InternetAddress _upnpIpV4Address = InternetAddress(_UPNP_IP_V4);
  RawDatagramSocket? _datagramSocket;

  SSDPService();

  bool get isRunning => _datagramSocket != null;

  Future<RawDatagramSocket> start() async {
    if (_datagramSocket != null) return _datagramSocket!;
    _datagramSocket = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4.address,
      _UPNP_PORT,
      reuseAddress: true,
      reusePort: true,
      ttl: 255,
    );
    _datagramSocket!
      ..multicastLoopback = false
      ..multicastHops = 12
      ..joinMulticast(_upnpIpV4Address);
    return _datagramSocket!;
  }

  void listen(void Function(String data) onData, {void Function()? onDone, Function? onError}) {
    _datagramSocket?.listen(
      (event) {
        if (event == RawSocketEvent.read) {
          final message = utf8.decode(_datagramSocket!.receive()!.data);
          onData.call(message);
        }
      },
      onDone: onDone,
      onError: onError,
    );
  }

  void sendMessage(UpnpMessage message) => send(message.data);

  void send(String data) {
    _datagramSocket?.send(const Utf8Codec().encode(data), _upnpIpV4Address, _UPNP_PORT);
  }

  void stop() {
    try {
      _datagramSocket?.close();
    } catch (e) {
      print(e.toString());
    }
    _datagramSocket = null;
  }
}
