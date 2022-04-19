// ignore_for_file: avoid_print

import 'package:my_dart_cast_demo/src/ssdp/ssdp_message_parser.dart';

const String _rootDevice = """
NOTIFY * HTTP/1.1\r
HOST: 239.255.255.250:1900\r
CACHE-CONTROL: max-age=66\r
LOCATION: http://192.168.3.119:49152/description.xml\r
NT: upnp:rootdevice\r
NTS: ssdp:alive\r
SERVER: Linux/3.10.61+, UPnP/1.0, Portable SDK for UPnP devices/1.6.13\r
USN: uuid:F7CA5454-3F48-4390-8009-403e48ef451f::upnp:rootdevice\r
""";

String _mediaRenderer = """
NOTIFY * HTTP/1.1\r
HOST: 239.255.255.250:1900\r
CACHE-CONTROL: max-age=66\r
LOCATION: http://192.168.3.119:49152/description.xml\r
NT: urn:schemas-upnp-org:device:MediaRenderer:1\r
NTS: ssdp:alive\r
SERVER: Linux/3.10.61+, UPnP/1.0, Portable SDK for UPnP devices/1.6.13\r
USN: uuid:F7CA5454-3F48-4390-8009-403e48ef451f::urn:schemas-upnp-org:device:MediaRenderer:1\r
""";

String _avTransport = """
NOTIFY * HTTP/1.1\r
HOST: 239.255.255.250:1900\r
CACHE-CONTROL: max-age=66\r
LOCATION: http://192.168.3.119:49152/description.xml\r
NT: urn:schemas-upnp-org:service:AVTransport:1\r
NTS: ssdp:alive\r
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

// HTTP/1.1 200 OK
// LOCATION: http://192.168.3.1:37215/2b38c15c-cb68-df90-3701-4f6df3dc9bb0/upnpdev.xml
// SERVER: Linux UPnP/1.0 Huawei-ATP-IGD
// HILINK_EXT: 0
// CACHE-CONTROL: max-age=86500
// EXT:
// ST: urn:www-huawei-com:service:NetworkSyncService:1
// USN: uuid:2b38c15c-cb68-df90-3701-4f6df3dc9bb0::urn:www-huawei-com:service:NetworkSyncService:1
// DATE: Mon, 18 Apr 2022 08:33:41 GMT

void main() {
  final parser = DiscoveryContentParser(
    processAlive: (String usn, String location, String cache) {
      print(">>>processAlive\n"
          "$usn\n"
          "$location\n"
          "$cache");
    },
    processByeBye: (String usn) {
      print(">>>processByeBye\n"
          "$usn");
    },
  );
  // parser.startParse(_rootDevice);
  // parser.startParse(_mediaRenderer);
  // parser.startParse(_avTransport);
  parser.startParse(_searchRootDevice);
  parser.startParse(_searchInternetGateway);
}
