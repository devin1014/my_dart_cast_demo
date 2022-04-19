// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/ssdp/ssdp_message_parser.dart';

String _notifyAlive = """
NOTIFY * HTTP/1.1\r
HOST: 239.255.255.250:1900\r
CACHE-CONTROL: max-age=66\r
LOCATION: http://192.168.3.119:49152/description.xml\r
NT: urn:schemas-upnp-org:device:MediaRenderer:1\r
NTS: ssdp:alive\r
SERVER: Linux/3.10.61+, UPnP/1.0, Portable SDK for UPnP devices/1.6.13\r
USN: uuid:F7CA5454-3F48-4390-8009-403e48ef451f::urn:schemas-upnp-org:device:MediaRenderer:1\r
""";

String _notifyByebye = """
NOTIFY * HTTP/1.1\r
HOST: 239.255.255.250:1900\r
CACHE-CONTROL: max-age=66\r
LOCATION: http://192.168.3.119:49152/description.xml\r
NT: urn:schemas-upnp-org:service:AVTransport:1\r
NTS: ssdp:byebye\r
SERVER: Linux/3.10.61+, UPnP/1.0, Portable SDK for UPnP devices/1.6.13\r
USN: uuid:F7CA5454-3F48-4390-8009-403e48ef451f::urn:schemas-upnp-org:service:AVTransport:1\r
""";

String _searchRootDevice = """
HTTP/1.1 200 OK\r
LOCATION: http://192.168.3.1:37215/2b38c15c-cb68-df90-3701-4f6df3dc9bb0/upnpdev.xml\r
SERVER: Linux UPnP/1.0 Huawei-ATP-IGD\r
HILINK_EXT: 0\r
CACHE-CONTROL: max-age=86500\r
EXT:\r
ST: upnp:rootdevice\r
USN: uuid:2b38c15c-cb68-df90-3701-4f6df3dc9bb0::upnp:rootdevice\r
DATE: Mon, 18 Apr 2022 08:33:41 GMT\r
""";

String _searchInternetGateway = """
HTTP/1.1 200 OK\r
LOCATION: http://192.168.3.1:37215/2b38c15c-cb68-df90-3701-4f6df3dc9bb0/upnpdev.xml\r
SERVER: Linux UPnP/1.0 Huawei-ATP-IGD\r
HILINK_EXT: 0\r
CACHE-CONTROL: max-age=86500\r
EXT:\r
ST: urn:schemas-upnp-org:device:InternetGatewayDevice:1\r
USN: uuid:2b38c15c-cb68-df90-3701-4f6df3dc9bb0::urn:schemas-upnp-org:device:InternetGatewayDevice:1\r
DATE: Mon, 18 Apr 2022 08:33:41 GMT\r
""";

void main() {
  final parser = SSDPMessageParser();

  test("parse alive", () {
    final device = parser.startParse(_notifyAlive);
    expect(true, device!.alive);
    expect("uuid:F7CA5454-3F48-4390-8009-403e48ef451f::urn:schemas-upnp-org:device:MediaRenderer:1", device.usn);
    expect("http://192.168.3.119:49152/description.xml", device.location);
  });

  test("parse byebye", () {
    final device = parser.startParse(_notifyByebye);
    expect(false, device!.alive);
  });

  test("parse device", () {
    final device = parser.startParse(_searchRootDevice);
    expect(true, device!.alive);
    expect("uuid:2b38c15c-cb68-df90-3701-4f6df3dc9bb0::upnp:rootdevice", device.usn);
    expect("http://192.168.3.1:37215/2b38c15c-cb68-df90-3701-4f6df3dc9bb0/upnpdev.xml", device.location);
  });
}
