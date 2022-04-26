// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/gena/gena.dart';
import 'package:my_dart_cast_demo/src/gena/gena_http_external.dart';
import 'package:my_dart_cast_demo/src/http/http_client.dart';

const url = "http://192.168.3.119:49152/_urn:schemas-upnp-org:service:AVTransport_event";
const callbackUrl = "http://192.168.3.137:8083/dlna/callback";

void main() {
  String sid = "";

  test("subscribe", () async {
    print("start subscribe");
    final response = await MyHttpClient().subscribe(url, callbackUrl: callbackUrl);
    final result = GENASubscribeResult.formResponse(response);
    sid = result.sid;
    expect(3600, result.cacheTime);
    expect(true, result.sid.startsWith("uuid:"));
  });

  test("resubscribe", () async {
    print("start resubscribe");
    // await Future.delayed(const Duration(milliseconds: 200), () {});
    final response = await MyHttpClient().resubscribe(url, sid: sid);
    final result = GENASubscribeResult.formResponse(response);
    expect(3600, result.cacheTime);
    expect(sid, result.sid);
  });

  test("resubscribe failed", () async {
    print("start resubscribe failed");
    // await Future.delayed(const Duration(milliseconds: 200), () {});
    final response = await MyHttpClient().resubscribe(url, sid: "$sid-666");
    final result = GENASubscribeResult.formResponse(response);
    expect(3600, result.cacheTime);
  });

  test("unsubscribe", () async {
    print("start unsubscribe");
    // await Future.delayed(const Duration(milliseconds: 200), () {});
    final response = await MyHttpClient().unsubscribe(url, sid: sid);
    final result = GENASubscribeResult.formResponse(response);
    expect(3600, result.cacheTime);
  });
}
