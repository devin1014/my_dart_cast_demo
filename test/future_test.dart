// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import '_test_util.dart';

void main() {
  test("Future sync", () async {
    print("start Future sync");
    final timeStamp = TimeStamp();
    final tag = timeStamp.tag();
    final num1 = await getNumberDelayed(1, milliseconds: 500);
    print("get num: $num1, cost:${timeStamp.get()} ms");
    final num2 = await getNumberDelayed(1, milliseconds: 500);
    print("get num: $num1, cost:${timeStamp.get()} ms");
    print("total: ${timeStamp.getTag(tag)} ms");
    expect(num1 + num2, 2);
  });

  test("Future async", () async {
    print("start Future async");
    final timeStamp = TimeStamp();
    final tag = timeStamp.tag();
    final future1 = getNumber(1, max: 500);
    final future2 = getNumber(1, max: 500);
    expect(await future1 + await future2, 2);
    print("total: ${timeStamp.getTag(tag)} ms");
  });

  test("Future.wait", () async {
    print("Future.wait start");
    final timeStamp = TimeStamp();
    final List<int> result = await Future.wait([getNumberDelayed(1), getNumberDelayed(2)]);
    final cost = timeStamp.get();
    expect(2, result.length);
    expect(3, result[0] + result[1]);
    print("total: $cost ms");
    expect(true, cost >= 500 && cost <= 600);
  });
}

final _random = Random(DateTime.now().millisecondsSinceEpoch);

Future<int> getNumber(int number, {int max = 500}) {
  return Future.delayed(Duration(milliseconds: _random.nextInt(max)), () => number);
}

Future<int> getNumberDelayed(int number, {int milliseconds = 500}) {
  return Future.delayed(Duration(milliseconds: milliseconds), () => number);
}
