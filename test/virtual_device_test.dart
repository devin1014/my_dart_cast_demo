// ignore_for_file: avoid_print

import 'dart:async';

import 'package:my_dart_cast_demo/src/virtual_device/virtual_device.dart';

/// http:localhost:59683/description.xml
///
void main() async {
  final builder = VirtualDeviceBuilder(
    deviceType: "urn:schemas-upnp-org:device:MediaRenderer:1",
    friendlyName: "My MediaRenderer",
  );
  // print(builder.description);
  final virtualDevice = builder.build();
  virtualDevice.start();

  final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (timer.isActive) {
      print(DateTime.now().toString());
    } else {
      print("timer die");
    }
  });
  await Future.delayed(const Duration(seconds: 60), () async {
    timer.cancel();
    await virtualDevice.stop();
  });
}
