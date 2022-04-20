// NOTIFY * HTTP/1.1
// HOST: 239.255.255.250:1900
// CACHE-CONTROL: max-age=66
// LOCATION: http://192.168.3.119:49152/description.xml
// NT: urn:schemas-upnp-org:service:AVTransport:1
// NTS: ssdp:alive
// SERVER: Linux/3.10.61+, UPnP/1.0, Portable SDK for UPnP devices/1.6.13
// USN: uuid:F7CA5454-3F48-4390-8009-403e48ef451f::urn:schemas-upnp-org:service:AVTransport:1

// ignore_for_file: avoid_print

import 'package:my_dart_cast_demo/src/dlna_device.dart';
import 'package:my_dart_cast_demo/src/soap/action_result.dart';
import 'package:my_dart_cast_demo/src/soap/av_transport_actions.dart';
import 'package:my_dart_cast_demo/src/ssdp/discovery_device_manager.dart';
import 'package:my_dart_cast_demo/src/util.dart';

const usn = "uuid:F7CA5454-3F48-4390-8009-403e48ef451f::urn:schemas-upnp-org:service:AVTransport:1";
const location = "http://192.168.3.119:49152/description.xml";

void main() async {
  final device = DLNADevice(usn: usn, location: location);
  device.detail = await DiscoveryDeviceManager().getDeviceDescription(device);
  final service = device.detail!.getService(SERVICE_AV_TRANSPORT);
  final GetTransportInfoResponse result = await GetTransportInfo(service!).execute();
  print(result.toJson().toString());
}
