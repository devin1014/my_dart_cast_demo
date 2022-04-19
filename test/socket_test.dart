// ignore_for_file: constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:io';

const String UPNP_IP_V4 = '239.255.255.250';
const int UPNP_PORT = 1900;
const String DLNA_M_SEARCH = 'M-SEARCH * HTTP/1.1\r\n' +
    'ST: ssdp:all\r\n' +
    'HOST: $UPNP_IP_V4:$UPNP_PORT\r\n' +
    'MX: 3\r\n' +
    'MAN: "ssdp:discover"\r\n\r\n';

void main() async {
  for (var element in (await NetworkInterface.list(
    type: InternetAddress.anyIPv4.type,
    includeLinkLocal: true,
    includeLoopback: true,
  ))) {
    print("$element");
  }

  final datagramSocket = await RawDatagramSocket.bind(
    InternetAddress.anyIPv4.address,
    UPNP_PORT,
    reuseAddress: true,
    reusePort: true,
    ttl: 255,
  );
  datagramSocket
    ..multicastLoopback = false
    ..multicastHops = 12
    ..joinMulticast(InternetAddress(UPNP_IP_V4))
    ..listen((event) {
      if (event == RawSocketEvent.read) {
        var message = utf8.decode(datagramSocket.receive()!.data);
        print(message);
      }
    });

  final dataToSend = const Utf8Codec().encode(DLNA_M_SEARCH);
  //print('Sending \'Search Message\' from ${socket.address.address}:${socket.port}');
  datagramSocket.send(dataToSend, InternetAddress(UPNP_IP_V4), UPNP_PORT);

  await Future.delayed(const Duration(seconds: 15), () {
    datagramSocket.close();
    print("complete");
  });
}
