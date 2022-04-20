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

void main() async {
  final data = await File("resources/description_mibox.xml").readAsString();
  final detail = DlnaParser.parseDeviceDetail(data, xml: true);

  void getInfo(AbstractServiceAction action) async {
    final result = await action.execute();
    print("\n${action.runtimeType.toString()}:\n$result");
  }

  /// ---------------------------------------------------------
  /// AvTransport
  /// ---------------------------------------------------------
  group("avTransportService", () {
    final DLNAService avTransportService = detail.serviceList.first;

    test("service url", () async {
      final url = avTransportService.baseUrl + "/" + avTransportService.controlUrl;
      print("url:\n" + url);
      expect("http://192.168.3.119:49152/_urn:schemas-upnp-org:service:AVTransport_control", url);
    });

    //TODO:
    test("GetCurrentTransportActions", () => getInfo(GetCurrentTransportActions(avTransportService)));

    test("GetTransportInfo", () => getInfo(GetTransportInfo(avTransportService)));

    test("GetPositionInfo", () => getInfo(GetPositionInfo(avTransportService)));

    test("GetMediaInfo", () => getInfo(GetMediaInfo(avTransportService)));

    //TODO:
    test("GetDeviceCapabilities", () => getInfo(GetDeviceCapabilities(avTransportService)));

    const longVideoUrl = "http://vfx.mtime.cn/Video/2019/03/19/mp4/190319212559089721.mp4";

    const shortVideoUrl = "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4";

    final didlObject = DIDLVideoObject(longVideoUrl);

    final nextDidlObject = DIDLVideoObject(shortVideoUrl);

    test("SetAVTransportURI", () => getInfo(SetAVTransportURI(avTransportService, didlObject)));

    test("SetNextAVTransportURI", () => getInfo(SetNextAVTransportURI(avTransportService, nextDidlObject)));

    test("Pause", () => getInfo(Pause(avTransportService)));

    test("Play", () => getInfo(Play(avTransportService)));
  });

  /// ---------------------------------------------------------
  /// ConnectionManager
  /// ---------------------------------------------------------
  group("connectionManager", () {
    final DLNAService connectionService = detail.serviceList[1];

    test("GetProtocolInfo", () => getInfo(GetProtocolInfo(connectionService)));
  });

  /// ---------------------------------------------------------
  /// RenderingControl
  /// ---------------------------------------------------------
  group("renderingControl", () {
    final DLNAService renderingControlService = detail.serviceList[2];

    print("actions:\n");
    renderingControlService.actionList?.forEach((element) {
      print(element.name);
    });

    test("GetMute", () => getInfo(GetMute(renderingControlService)));

    test("GetVolume", () => getInfo(GetVolume(renderingControlService)));

    test("SetMute", () => getInfo(SetMute(renderingControlService)));

    test("SetVolume", () => getInfo(SetVolume(renderingControlService)));
  });
}
