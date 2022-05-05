// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/parser.dart';
import 'package:my_dart_cast_demo/src/virtual_device/virtual_device_builder.dart';

void main() async {
  final builder = VirtualDeviceBuilder(
    deviceType: "MediaRenderer",
    deviceName: "Virtual Device",
    serviceTypes: ["AVTransport", "ConnectionManager", "RenderingControl"],
  );

  print(builder.description);

  test("parse description", () {
    final description = DlnaParser.parseDeviceDetail(builder.description, xml: true);
    expect("urn:schemas-upnp-org:device:MediaRenderer:1", description.deviceType);
    expect("Virtual Device", description.friendlyName);
    expect("urn:schemas-upnp-org:service:AVTransport:1", description.serviceList.first.type);
    expect("urn:schemas-upnp-org:service:RenderingControl:1", description.serviceList.last.type);
  });
}
