// ignore_for_file: constant_identifier_names, avoid_print, prefer_adjacent_string_concatenation

import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
  static const String DLNA_MESSAGE_SEARCH = 'M-SEARCH * HTTP/1.1\r\n' +
      'ST: ssdp:all\r\n' +
      'HOST: 239.255.255.250:1900\r\n' +
      'MX: 3\r\n' +
      'MAN: "ssdp:discover"\r\n\r\n';

  final InternetAddress _upnpIpV4Address = InternetAddress(_UPNP_IP_V4);
  final RawDatagramSocketFactory _rawDatagramSocketFactory;
  RawDatagramSocket? _datagramSocket;

  SSDPService({
    RawDatagramSocketFactory factory = RawDatagramSocket.bind,
  }) : _rawDatagramSocketFactory = factory;

  Future<RawDatagramSocket> start() async {
    if (_datagramSocket != null) return _datagramSocket!;
    _datagramSocket = await _rawDatagramSocketFactory(
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

  void sendMessage(String message) {
    _datagramSocket?.send(const Utf8Codec().encode(message), _upnpIpV4Address, _UPNP_PORT);
  }

  void stop() {
    try {
      _datagramSocket?.close();
    } catch (e) {
      print(e.toString());
    }
  }
}
