// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/dlna_service.dart';
import 'package:my_dart_cast_demo/src/parser.dart';
import 'package:my_dart_cast_demo/src/soap/av_transport_actions.dart';
import 'package:my_dart_cast_demo/src/soap/connection_manager_actions.dart';
import 'package:my_dart_cast_demo/src/soap/didl_object.dart';
import 'package:my_dart_cast_demo/src/soap/rendering_control_actions.dart';
import 'package:my_dart_cast_demo/src/soap/service_actions.dart';

const longVideoUrl = "http://vfx.mtime.cn/Video/2019/03/19/mp4/190319212559089721.mp4";
const shortVideoUrl = "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4";

void main() async {
  final data = await File("resources/description_mibox.xml").readAsString();
  final detail = DlnaParser.parseDeviceDetail(data, xml: true);

  /// ---------------------------------------------------------
  /// AvTransport
  /// ---------------------------------------------------------
  group("avTransportService", () {
    final DLNAService avTransportService = detail.serviceList.first;

    test("SetAVTransportURI",
        () => logActionResult(SetAVTransportURI(avTransportService, DIDLVideoObject(longVideoUrl))));

    test("SetNextAVTransportURI",
        () => logActionResult(SetNextAVTransportURI(avTransportService, DIDLVideoObject(shortVideoUrl))));

    test("Pause", () => logActionResult(Pause(avTransportService)));

    test("Play", () => logActionResult(Play(avTransportService)));

    test("Seek", () => logActionResult(Seek(avTransportService, realPosition: 30)));

    test("Stop", () => logActionResult(Stop(avTransportService)));

    test("GetPositionInfo", () => logActionResult(GetPositionInfo(avTransportService)));

    test("GetMediaInfo", () => logActionResult(GetMediaInfo(avTransportService)));

    test("GetTransportInfo", () => logActionResult(GetTransportInfo(avTransportService)));

    test("GetTransportSettings", () => logActionResult(GetTransportSettings(avTransportService)));

    //TODO: GetCurrentTransportActions, GetDeviceCapabilities failed.
    test("GetCurrentTransportActions", () => logActionResult(GetCurrentTransportActions(avTransportService)));

    test("GetDeviceCapabilities", () => logActionResult(GetDeviceCapabilities(avTransportService)));
  });

  /// ---------------------------------------------------------
  /// ConnectionManager
  /// ---------------------------------------------------------
  group("connectionManager", () {
    final DLNAService connectionService = detail.serviceList[1];

    test("GetProtocolInfo", () => logActionResult(GetProtocolInfo(connectionService)));
  });

  /// ---------------------------------------------------------
  /// RenderingControl
  /// ---------------------------------------------------------
  group("renderingControl", () {
    final DLNAService renderingControlService = detail.serviceList[2];

    renderingControlService.actionList?.forEach((element) {
      print(element.name);
    });

    test("GetMute", () => logActionResult(GetMute(renderingControlService)));

    test("GetVolume", () => logActionResult(GetVolume(renderingControlService)));

    test("SetMute", () => logActionResult(SetMute(renderingControlService)));

    test("SetVolume", () => logActionResult(SetVolume(renderingControlService)));
  });

  /// ---------------------------------------------------------
  /// Url
  /// ---------------------------------------------------------
  group("service url", () {
    final DLNAService avTransportService = detail.serviceList.first;

    test("service url", () async {
      final url = avTransportService.baseUrl + "/" + avTransportService.controlUrl;
      print("url:\n" + url);
      expect("http://192.168.3.119:49152/_urn:schemas-upnp-org:service:AVTransport_control", url);
    });
  });
}

void logActionResult(AbstractServiceAction action) async {
  final result = await action.execute();
  print("\n${action.runtimeType.toString()}:\n$result");
}
