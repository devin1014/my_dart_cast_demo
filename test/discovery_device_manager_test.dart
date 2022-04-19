// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/dlna_device.dart';
import 'package:my_dart_cast_demo/src/ssdp/discovery_device_manager.dart';

void main() async {
  List<DLNADevice> list = [];

  final DiscoveryDeviceManager manager = DiscoveryDeviceManager();

  manager.listen(
    onDeviceAdd: (device) {
      list.add(device);
    },
    onDeviceRemove: (device) {
      list.remove(device);
    },
  );

  manager.search();

  await Future.delayed(const Duration(seconds: 10), () {});

  for (var element in list) {
    print(element.toJson().toString());
  }
}
