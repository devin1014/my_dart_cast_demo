// ignore_for_file: avoid_print

import 'dart:async';

import 'package:my_dart_cast_demo/src/ssdp/ssdp_service.dart';

const filterLogging = true;

void main() async {
  final service = SSDPService();

  await service.start();

  service.listen((data) {
    print(data);
  });

  Timer.periodic(const Duration(seconds: 10), (timer) {
    print("timer:${timer.tick}");
    service.search();
  });

  await Future.delayed(const Duration(seconds: 60), () {
    service.stop();
  });
}
