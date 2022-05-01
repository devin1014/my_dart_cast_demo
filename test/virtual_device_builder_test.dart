// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/parser.dart';
import 'package:my_dart_cast_demo/src/virtual_device/virtual_device.dart';

void main() async {
  final builder = VirtualDeviceBuilder(
    host: "192.168.3.137",
    port: 56789,
    deviceType: "urn:schemas-upnp-org:device:MediaRenderer:1",
    friendlyName: "My MediaRenderer",
  );
  print(builder.description);
  test("parse description", () {
    final description = DlnaParser.parseDeviceDetail(builder.description, xml: true);
    expect("urn:schemas-upnp-org:device:MediaRenderer:1", description.deviceType);
  });
}
