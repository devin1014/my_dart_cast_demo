// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/dlna_device.dart';
import 'package:my_dart_cast_demo/src/ssdp/discovery_device_manager.dart';

const usn = "uuid:F7CA5454-3F48-4390-8009-403e48ef451f::urn:schemas-upnp-org:device:MediaRenderer:1";
const location = "http://192.168.3.119:49152/description.xml";
const cache = "max-age=66";

void main() async {
  List<DLNADevice> list = [];

  void onDeviceAdd(DLNADevice device) {
    list.add(device);
  }

  void onDeviceUpdate(DLNADevice device) {
    // ignore
  }

  void onDeviceRemove(DLNADevice device) {
    list.remove(device);
  }

  final DiscoveryDeviceManager manager = DiscoveryDeviceManager(
    onDeviceAdd: onDeviceAdd,
    onDeviceUpdate: onDeviceUpdate,
    onDeviceRemove: onDeviceRemove,
  );

  await manager.alive(usn, location, cache);

  test("device alive", () {
    expect(1, list.length);
    expect(usn, list[0].usn);
    expect(location, list[0].location);
  });

  test("device byebye", () {
    manager.byeBye(usn);
    expect(0, list.length);
  });
}
