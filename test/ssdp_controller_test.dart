// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: avoid_print

import 'dart:io';

import 'package:my_dart_cast_demo/src/ssdp/ssdp_controller.dart';

void main() async {
  await testSSDPController();
  // await testInternetInfo();
}

Future<bool> testSSDPController() async {
  final controller = SSDPController();
  controller.listen((event) {
    print("----------------");
    print("receive:\n$event");
  });
  await controller.startSearch();
  return await Future.delayed(const Duration(seconds: 10), () {
    controller.stop();
    return true;
  });
}

Future<bool> testInternetInfo() async {
  final InternetAddress anyIPv4 = InternetAddress.anyIPv4;
  print(anyIPv4.toString());

  final Iterable<NetworkInterface> interfaces = await NetworkInterface.list(
    includeLinkLocal: true,
    type: InternetAddress.anyIPv4.type,
    includeLoopback: true,
  );
  for (var element in interfaces) {
    print(element);
  }
  return true;
}
