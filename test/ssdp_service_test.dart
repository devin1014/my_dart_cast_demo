// ignore_for_file: avoid_print

import 'package:my_dart_cast_demo/src/ssdp/ssdp_service.dart';

void main() async {
  final service = SSDPService(onData: (data) {
    print(data);
  });

  await service.start();

  service.sendMessage(SSDPService.DLNA_MESSAGE_SEARCH);

  await Future.delayed(const Duration(seconds: 15), () {
    service.stop();
  });
}
