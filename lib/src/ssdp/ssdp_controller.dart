// ignore_for_file: constant_identifier_names, avoid_print, prefer_adjacent_string_concatenation

import 'dart:async';
import 'dart:convert';
import 'dart:io';

typedef NetworkInterfacesFactory = Future<Iterable<NetworkInterface>> Function(InternetAddressType type);

typedef RawDatagramSocketFactory = Future<RawDatagramSocket> Function(dynamic host, int port,
    {bool reuseAddress, bool reusePort, int ttl});

class SSDPController {
  static const String UPNP_IP_V4 = '239.255.255.250';
  static const int UPNP_PORT = 1900;
  static const String DLNA_M_SEARCH = 'M-SEARCH * HTTP/1.1\r\n' +
      'ST: ssdp:all\r\n' +
      'HOST: $UPNP_IP_V4:$UPNP_PORT\r\n' +
      'MX: 3\r\n' +
      'MAN: \"ssdp:discover\"\r\n\r\n';

  // final InternetAddress _upnpAddressIPv4 = InternetAddress(UPNP_IP_V4);
  //final InternetAddress _upnpAddressIPv6 = InternetAddress('FF02::FB');

  final InternetAddress _upnpInternetAddress = InternetAddress(UPNP_IP_V4);
  final int _port = UPNP_PORT;

  final RawDatagramSocketFactory _rawDatagramSocketFactory;
  final List<RawDatagramSocket> _sockets = <RawDatagramSocket>[];
  final StreamController<String> controller = StreamController<String>();
  late RawDatagramSocket _incoming;
  Timer? _timer;

  SSDPController({
    RawDatagramSocketFactory factory = RawDatagramSocket.bind,
  }) : _rawDatagramSocketFactory = factory;

  bool _starting = false;
  bool _started = false;

  Future<void> start() async {
    if (_started || _starting) {
      print("SSDPController has started or is starting...");
      return;
    }
    print("SSDPController starting.");
    _starting = true;

    _incoming = await _rawDatagramSocketFactory(
      InternetAddress.anyIPv4.address,
      _port,
      reuseAddress: true,
      reusePort: true,
      ttl: 255,
    );
    _incoming.multicastLoopback = false;
    _incoming.multicastHops = 12;
    _sockets.add(_incoming);

    final Iterable<NetworkInterface> networkInterfaces = await NetworkInterface.list(
      type: InternetAddress.anyIPv4.type,
      includeLinkLocal: true,
      includeLoopback: true,
    );
    print("networkInterfaces: ${networkInterfaces.length}");
    for (var interface in networkInterfaces) {
      print("network: $interface");
      final address = interface.addresses[0];
      final socket = await _rawDatagramSocketFactory(
        address,
        _port,
        reuseAddress: true,
        reusePort: true,
        ttl: 255,
      );
      socket.multicastLoopback = false;
      socket.setRawOption(RawSocketOption(
        RawSocketOption.levelIPv4,
        RawSocketOption.IPv4MulticastInterface,
        address.rawAddress,
      ));
      _sockets.add(socket);

      _incoming.joinMulticast(_upnpInternetAddress, interface);
    }
    _incoming.listen(_handleIncoming);
    print("SSDPController started.");
    _started = true;
    _starting = false;
  }

  void stop() {
    if (!_started) {
      print("SSDPController has not started.");
      return;
    }
    if (_starting) {
      throw StateError('Cannot stop mDNS client while it is starting.');
    }
    _timer?.cancel();
    controller.close();
    for (var socket in _sockets) {
      socket.close();
    }
    _started = false;
    print("SSDPController stopped.");
  }

  final _sendDuration = const Duration(milliseconds: 10 * 1000);

  void send() {
    if (!_started) {
      throw StateError('mDNS client must be started before calling lookup.');
    }
    final dataToSend = const Utf8Codec().encode(DLNA_M_SEARCH);
    _timer = Timer.periodic(_sendDuration, (Timer t) {
      for (var socket in _sockets) {
        print('Sending \'Search Message\' from ${socket.address.address}:${socket.port}');
        socket.send(dataToSend, _upnpInternetAddress, _port);
      }
    });
  }

  void _handleIncoming(RawSocketEvent event) {
    if (event == RawSocketEvent.read) {
      var packet = _incoming.receive()?.data;
      var message = utf8.decode(packet!);
      controller.add(message);
    }
  }

  Future<void> startSearch() async {
    await start();
    send();
  }

  void listen(void Function(String event) onData) {
    if (controller.isClosed) {
      return;
    }
    controller.stream.listen(onData);
  }
}
