// ignore_for_file: avoid_print

import 'dart:io';

void main() async {
  for (var element in (await NetworkInterface.list(
    type: InternetAddress.anyIPv4.type,
    includeLinkLocal: true,
    includeLoopback: true,
  ))) {
    print("$element");
  }
}
