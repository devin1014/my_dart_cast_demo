import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/parser.dart';
import 'package:my_dart_cast_demo/src/soap/av_transport_actions.dart';

void main() async {
  final data = await File("resources/description_mibox.xml").readAsString();
  final detail = DlnaParser.parseDeviceDetail(data, xml: true);

  test("SetAVTransportURI", () async {
    final data = await SetAVTransportURI().parseAction(detail.baseURL, detail.serviceList.first);
    print(data);
  });
}
