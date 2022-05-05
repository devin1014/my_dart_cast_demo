// ignore_for_file: avoid_print

import 'dart:async';

import 'package:my_dart_cast_demo/src/ssdp/ssdp_service.dart';
import 'package:my_dart_cast_demo/src/ssdp/upnp_message.dart';

import '_test_util.dart';

const int _searchTime = 60;
const tag = "SSDPService";

void main() async {
  final service = SSDPService();

  await service.start();

  printLog(tag, "ssdp started");

  service.listen((data) {
    printlnLog(tag, data);
  });

  _search(service);

  // _notify(service);

  await Future.delayed(const Duration(seconds: _searchTime), () {
    service.stop();
  });
}

const String _searchMessage = 'M-SEARCH * HTTP/1.1\r\n' +
    'HOST: 239.255.255.250:1900\r\n' +
    'MAN: "ssdp:discover"\r\n' +
    'ST: ssdp:all\r\n' +
    'MX: 3\r\n' +
    '\r\n';

void _search(SSDPService service) {
  final message = UpnpMessage.search("ssdp:all");
  printlnLog(tag, message);
  // printlnLog("SSDPService", _searchMessage);
  // printlnLog("SSDPService", "${message.data == _searchMessage}");
  service.send(_searchMessage);

  Timer.periodic(const Duration(seconds: 10), (timer) {
    printLog(tag, "timer:${timer.tick * 10} s");
    service.sendMessage(message);
    // service.send(_searchMessage);
  });
}

void _notify(SSDPService service) {
  const usn = "uuid:F7CA5454-3F48-4390-8009-403e48ef451f";
  const location = "http://192.168.3.119:49152/description.xml";
  const ntList = [
    "upnp:rootdevice",
    "urn:schemas-upnp-org:device:MediaRenderer:1",
    "urn:schemas-upnp-org:service:AVTransport:1",
    "urn:schemas-upnp-org:service:ConnectionManager:1",
    "urn:schemas-upnp-org:service:RenderingControl:1",
  ];
  final messageList = UpnpMessage.buildNotifyList(usn: usn, location: location, ntList: ntList);
  for (var element in messageList) {
    printlnLog(tag, element);
    service.sendMessage(element);
  }

  // Timer.periodic(const Duration(seconds: 10), (timer) {
  //   printLog(tag, "timer:${timer.tick * 10} s");
  //   for (var element in messageList) {
  //     service.sendMessage(element);
  //   }
  // });
}
