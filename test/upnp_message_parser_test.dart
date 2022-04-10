// ignore_for_file: avoid_print

import 'package:my_dart_cast_demo/src/ssdp/upnp_message_parser.dart';

const String message = "";
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
  parser.startParse(_rootDevice);
  parser.startParse(_mediaRenderer);
  parser.startParse(_avTransport);
}
