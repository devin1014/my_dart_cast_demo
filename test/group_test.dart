// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';

void main() {
  test("test1", () async {
    const tag = "test1";
    print("$tag start");
    await Future.delayed(const Duration(milliseconds: 100), () {});
    print("$tag complete");
  });

  test("test exception", () async {
    const tag = "test exception";
    print("$tag start");
    await Future.delayed(const Duration(milliseconds: 100), () {});
    throw Exception("$tag error!");
  });

  test("test2", () async {
    const tag = "test2";
    print("$tag start");
    await Future.delayed(const Duration(milliseconds: 100), () {});
    print("$tag complete");
  });
}
