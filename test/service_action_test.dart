// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/dlna_service.dart';
import 'package:my_dart_cast_demo/src/http/http_client.dart';
import 'package:my_dart_cast_demo/src/parser.dart';

void main() async {
  final data = await File("resources/description.xml").readAsString();
  final detail = DlnaParser.parseDeviceDetail(data, xml: true);

  test("service action", () async {
    final futures = detail.serviceList.map((e) => _getServiceAction(e));
    await Future.wait(futures);

    for (var element in detail.serviceList) {
      print("${element.type} -> ${element.actionList?.length}");
    }
  });
}

Future<void> _getServiceAction(DLNAService service) async {
  final url = service.baseUrl + service.scpdUrl;
  final response = await MyHttpClient().getUrl(url);
  service.actionList = DlnaParser.parseServiceAction(response, xml: true);
}
