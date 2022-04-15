// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/http/http_client.dart';
import 'package:my_dart_cast_demo/src/parser.dart';

void main() async {
  final data = await File("resources/description.xml").readAsString();
  final detail = DlnaParser.parseDeviceDetail(data, xml: true);

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
    final baseUrl = detail.baseURL;
    final scpdUrl = detail.serviceList.first.scpdUrl;
    final url = baseUrl + scpdUrl;
    final response = await MyHttpClient().getUrl(url);
    final result = DlnaParser.parseServiceAction(response, xml: true);

    final action = result!.first;

    expect("GetCurrentTransportActions", action.name);

    expect("InstanceID", action.argument.first.name);
    expect("in", action.argument.first.direction);
    expect("A_ARG_TYPE_InstanceID", action.argument.first.relatedStateVariable);

    expect("Actions", action.argument.last.name);
    expect("out", action.argument.last.direction);
    expect("CurrentTransportActions", action.argument.last.relatedStateVariable);
  });
}
