// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/dlna_device.dart';
import 'package:xml2json/xml2json.dart';

void main() async {
  final data = await File("resources/AVTransport_scpd.xml").readAsString();
  final xml2Json = Xml2Json();
  xml2Json.parse(data);
  final jsonObj = jsonDecode(xml2Json.toParker()) as Map<String, dynamic>;
  // final result = jsonEncode(jsonDecode(xml2Json.toParker()));
  final List<dynamic> list = jsonObj["scpd"]["actionList"]["action"];
  final Map<String, dynamic> obj = list.first as Map<String, dynamic>;
  final action = DLNAServiceAction.fromJson(obj);
  print(action.toJson());
  test("parse action", () {
    expect("GetCurrentTransportActions", action.name);

    expect("InstanceID", action.argument.first.name);
    expect("in", action.argument.first.direction);
    expect("A_ARG_TYPE_InstanceID", action.argument.first.relatedStateVariable);

    expect("Actions", action.argument.last.name);
    expect("out", action.argument.last.direction);
    expect("CurrentTransportActions", action.argument.last.relatedStateVariable);
  });
}
