// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/dlna_device.dart';
import 'package:my_dart_cast_demo/src/parser.dart';
import 'package:my_dart_cast_demo/src/soap/av_transport_actions.dart';
import 'package:my_dart_cast_demo/src/soap/connection_manager_actions.dart';
import 'package:my_dart_cast_demo/src/soap/rendering_control_actions.dart';
import 'package:my_dart_cast_demo/src/soap/service_actions.dart';

void main() async {
  final data = await File("resources/description.xml").readAsString();
  final detail = DlnaParser.parseDeviceDetail(data, xml: true);

  void getInfo(AbstractServiceAction action, DLNAService service) async {
    final result = await action.parseAction(detail.baseURL, service);
    print("\n${action.runtimeType.toString()}:\n$result");
  }

  /// ---------------------------------------------------------
  /// AvTransport
  /// ---------------------------------------------------------
  group("avTransportService", () {
    final DLNAService avTransportService = detail.serviceList.first;

    test("service url", () async {
      final url = detail.baseURL + "/" + avTransportService.controlUrl;
      print("url:\n" + url);
      expect("http://192.168.3.119:49152/_urn:schemas-upnp-org:service:AVTransport_control", url);
    });

    test("GetCurrentTransportActions", () => getInfo(GetCurrentTransportActions(), avTransportService));

    test("GetTransportInfo", () => getInfo(GetTransportInfo(), avTransportService));

    test("GetPositionInfo", () => getInfo(GetPositionInfo(), avTransportService));

    test("GetMediaInfo", () => getInfo(GetMediaInfo(), avTransportService));
  });
  // test("GetDeviceCapabilities", () => getInfo(GetDeviceCapabilities()));

  /// ---------------------------------------------------------
  /// ConnectionManager
  /// ---------------------------------------------------------
  group("connectionManager", () {
    final DLNAService connectionService = detail.serviceList[1];

    test("GetProtocolInfo", () => getInfo(GetProtocolInfo(), connectionService));
  });

  /// ---------------------------------------------------------
  /// RenderingControl
  /// ---------------------------------------------------------
  group("renderingControl", () {
    final DLNAService renderingControlService = detail.serviceList[2];

    test("GetMute", () => getInfo(GetMute(), renderingControlService));

    test("GetVolume", () => getInfo(GetVolume(), renderingControlService));

    test("SetMute", () => getInfo(SetMute(), renderingControlService));

    test("SetVolume", () => getInfo(SetVolume(), renderingControlService));
  });
}
