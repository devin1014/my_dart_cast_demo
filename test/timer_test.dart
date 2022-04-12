// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'util.dart';

void main() {
  testTimer();
  testPeriodic();
}

void testTimer() async {
  test("timer", () async {
    printWithTime("start");
    Timer(const Duration(seconds: 1), () {
      printWithTime("run");
    });
    await Future.delayed(const Duration(seconds: 1), () {
      printWithTime("complete");
    });
  });
}

void testPeriodic() async {
  test("timer periodic", () async {
    final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      printWithTime("run, ${timer.tick}");
    });
    await Future.delayed(const Duration(seconds: 6), () {
      timer.cancel();
      printWithTime("complete");
    });
  });
}
