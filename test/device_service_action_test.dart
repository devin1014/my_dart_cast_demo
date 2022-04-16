// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/dlna_device.dart';
import 'package:my_dart_cast_demo/src/parser.dart';
import 'package:my_dart_cast_demo/src/soap/av_transport_service_action.dart';
import 'package:my_dart_cast_demo/src/soap/service_action.dart';

void main() async {
  final data = await File("resources/description.xml").readAsString();
  final detail = DlnaParser.parseDeviceDetail(data, xml: true);
  final DLNAService avTransportService = detail.serviceList.first;
  final url = detail.baseURL + "/" + avTransportService.controlUrl;
  print("url:\n" + url);

  test("service url", () async {
    expect("http://192.168.3.119:49152/_urn:schemas-upnp-org:service:AVTransport_control", url);
  });

  void getInfo(AbstractServiceAction action) async {
    final result = await action.parseAction(detail.baseURL, avTransportService);
    print("\n${action.runtimeType.toString()}:\n$result");
  }

  test("GetCurrentTransportActions", () => getInfo(GetCurrentTransportActions()));

  test("GetTransportInfo", () => getInfo(GetTransportInfo()));

  test("GetPositionInfo", () => getInfo(GetPositionInfo()));

  test("GetMediaInfo", () => getInfo(GetMediaInfo()));

  test("GetDeviceCapabilities", () => getInfo(GetDeviceCapabilities()));
  }
