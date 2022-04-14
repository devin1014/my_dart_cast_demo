// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/parser.dart';

void main() async {
  final data = await File("resources/AVTransport_scpd.xml").readAsString();

  final result = DlnaParser.parseServiceAction(data, xml: true);

  test("parse action", () {
    final action = result.first;

    expect("GetCurrentTransportActions", action.name);

    expect("InstanceID", action.argument.first.name);
    expect("in", action.argument.first.direction);
    expect("A_ARG_TYPE_InstanceID", action.argument.first.relatedStateVariable);

    expect("Actions", action.argument.last.name);
    expect("out", action.argument.last.direction);
    expect("CurrentTransportActions", action.argument.last.relatedStateVariable);
  });
}
