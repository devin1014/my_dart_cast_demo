// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/dlna_device.dart';
import 'package:my_dart_cast_demo/src/parser.dart';

void main() async {
  final data = await File("resources/description.xml").readAsString();
  final jsonObj = parseXml2Json(data)['root'];
  final detail = DLNADeviceDetail.fromJson(jsonObj['device']);
  detail.baseURL = jsonObj["URLBase"];

  test("parse dlna device description", () async {
    expect(detail.friendlyName, "客厅的小米盒子");
    expect(detail.deviceType, "urn:schemas-upnp-org:device:MediaRenderer:1");
    expect(detail.serviceList.length, 4);

    final service = detail.serviceList.first;
    expect(service.type, "urn:schemas-upnp-org:service:AVTransport:1");
    expect(service.serviceId, "urn:upnp-org:serviceId:AVTransport");
    expect(service.scpdUrl, "/dlna/Render/AVTransport_scpd.xml");
    expect(service.controlUrl, "_urn:schemas-upnp-org:service:AVTransport_control");
    expect(service.eventSubUrl, "_urn:schemas-upnp-org:service:AVTransport_event");
  });

  test("scpd", () async {
    final avTransportService = detail.serviceList.first;
    avTransportService.scpdUrl;
  });
}
