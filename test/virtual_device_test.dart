// ignore_for_file: avoid_print

import 'dart:async';

import 'package:my_dart_cast_demo/src/virtual_device/virtual_device_builder.dart';

import '_test_util.dart';

void main() async {
  const tag = "VirtualDevice";
  final builder = VirtualDeviceBuilder(
    deviceType: "MediaRenderer",
    deviceName: "Virtual Device",
    serviceTypes: ["AVTransport", "ConnectionManager", "RenderingControl"],
  );
  // print(builder.description);
  final virtualDevice = builder.build();
  await virtualDevice.start();

  printLog(tag, virtualDevice);

  final timer = Timer.periodic(const Duration(seconds: 10), (timer) {
    printLog(tag, timer.isActive ? timer.tick : "die");
  });
  await Future.delayed(const Duration(seconds: 60), () async {
    timer.cancel();
    await virtualDevice.stop();
  });
}
