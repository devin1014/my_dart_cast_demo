// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/http/http_client.dart';
import 'package:my_dart_cast_demo/src/parser.dart';

void main() async {
  /// --------------------------
  /// MiBox
  /// --------------------------
  final miBoxDetail = DlnaParser.parseDeviceDetail(
    await File("resources/description_mibox.xml").readAsString(),
    xml: true,
  );

  group("testMiBoxDevice", () {
    test("parse dlna device description", () async {
      expect(miBoxDetail.friendlyName, "客厅的小米盒子");
      expect(miBoxDetail.deviceType, "urn:schemas-upnp-org:device:MediaRenderer:1");
      expect(miBoxDetail.serviceList.length, 4);

      final service = miBoxDetail.serviceList.first;
      expect(service.type, "urn:schemas-upnp-org:service:AVTransport:1");
      expect(service.serviceId, "urn:upnp-org:serviceId:AVTransport");
      expect(service.scpdUrl, "/dlna/Render/AVTransport_scpd.xml");
      expect(service.controlUrl, "_urn:schemas-upnp-org:service:AVTransport_control");
      expect(service.eventSubUrl, "_urn:schemas-upnp-org:service:AVTransport_event");
    });

    test("scpd", () async {
      final baseUrl = miBoxDetail.baseURL;
      final scpdUrl = miBoxDetail.serviceList.first.scpdUrl;
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
  });

  /// --------------------------
  /// Samsung S7
  /// --------------------------
  final samsungS7Detail = DlnaParser.parseDeviceDetail(
    await File("resources/description_samsung_s7.xml").readAsString(),
    xml: true,
  );
  group("testSamsungS7Device", () {
    test("parse dlna device description", () async {
      expect(samsungS7Detail.friendlyName, "DMR (SM-G935U)");
      expect(samsungS7Detail.deviceType, "urn:schemas-upnp-org:device:MediaRenderer:1");
      expect(samsungS7Detail.serviceList.length, 3);

      final service = samsungS7Detail.serviceList.first;
      expect(service.type, "urn:schemas-upnp-org:service:AVTransport:1");
      expect(service.serviceId, "urn:upnp-org:serviceId:AVTransport");
      expect(service.scpdUrl, "/upnp/dev/e90bf43e-4b0c-9362-0000-000049ba23c5/svc/upnp-org/AVTransport/desc");
      expect(service.controlUrl, "/upnp/dev/e90bf43e-4b0c-9362-0000-000049ba23c5/svc/upnp-org/AVTransport/action");
      expect(service.eventSubUrl, "/upnp/dev/e90bf43e-4b0c-9362-0000-000049ba23c5/svc/upnp-org/AVTransport/event");
    });

    test("scpd", () async {
      final baseUrl = samsungS7Detail.baseURL;
      final scpdUrl = samsungS7Detail.serviceList.first.scpdUrl;
      final url = baseUrl + scpdUrl;
      final response = await MyHttpClient().getUrl(url);
      final result = DlnaParser.parseServiceAction(response, xml: true);

      final action = result!.first;

      expect("Pause", action.name);

      expect("InstanceID", action.argument.first.name);
      expect("in", action.argument.first.direction);
      expect("A_ARG_TYPE_InstanceID", action.argument.first.relatedStateVariable);
    });
  });
}
