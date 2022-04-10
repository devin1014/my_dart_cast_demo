// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/ssdp/description_parser.dart';

void main() {
  test("parse dlna device description", () async {
    final data = await File("resources/xiaomi_box_dlna_description.xml").readAsString();
    final description = await DescriptionParser().getDescription(data);

    expect(description.friendlyName, "客厅的小米盒子");
    expect(description.deviceType, "urn:schemas-upnp-org:device:MediaRenderer:1");
    expect(description.serviceList.length, 4);

    final service = description.serviceList.first;
    expect(service.type, "urn:schemas-upnp-org:service:AVTransport:1");
    expect(service.serviceId, "urn:upnp-org:serviceId:AVTransport");
    expect(service.scpdUrl, "/dlna/Render/AVTransport_scpd.xml");
    expect(service.controlUrl, "_urn:schemas-upnp-org:service:AVTransport_control");
    expect(service.eventSubUrl, "_urn:schemas-upnp-org:service:AVTransport_event");
  });
}
