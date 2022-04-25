// ignore_for_file: avoid_print

import 'dart:io';

/// sid: uuid:5ea1656c-1dd2-11b2-abdd-80c3b3a5f2fe
/// timeout: Second-3600
/// date: Sun, 24 Apr 2022 07:22:59 GMT
class GENASubscribeResult {
  final String sid;

  /// unit second
  int cacheTime = 3600;
  int expirationTime = -1;

  GENASubscribeResult(
    this.sid,
    String timeout,
    String date,
  ) {
    try {
      cacheTime = int.parse(timeout.split("-").last);
    } catch (e) {
      print(e.toString());
    }
    expirationTime = DateTime.now().millisecondsSinceEpoch + cacheTime * 1000;
  }

  bool get isExpired => DateTime.now().millisecondsSinceEpoch > expirationTime;

  int get aliveTime => expirationTime - DateTime.now().millisecondsSinceEpoch;

  factory GENASubscribeResult.formResponse(HttpClientResponse response) {
    final headers = response.headers;
    final sid = headers["sid"]?.first ?? "";
    final timeout = headers["timeout"]?.first ?? "";
    final date = headers["date"]?.first ?? "";
    return GENASubscribeResult(sid, timeout, date);
  }
}
