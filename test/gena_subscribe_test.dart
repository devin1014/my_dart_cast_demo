// ignore_for_file: avoid_print

import 'package:my_dart_cast_demo/src/gena/gena.dart';
import 'package:my_dart_cast_demo/src/gena/gena_http_external.dart';
import 'package:my_dart_cast_demo/src/http/http_client.dart';

const url = "http://192.168.3.119:49152/_urn:schemas-upnp-org:service:AVTransport_event";
const callbackUrl = "http://192.168.3.137:8083/dlna/callback";

String sid = "";

void main() async {
  await subscribe();
  // resubscribe(sid);
  // unsubscribe(sid);
}

Future<GENASubscribeResult> subscribe() async {
  final response = await MyHttpClient().subscribe(url, callbackUrl: callbackUrl);
  final result = GENASubscribeResult.formResponse(response);
  sid = result.sid;
  print(sid);
  return result;
}

void resubscribe(String sid) async {
  final response = await MyHttpClient().resubscribe(url, sid: sid);
  final result = GENASubscribeResult.formResponse(response);
}

unsubscribe(String sid) async {
  final response = await MyHttpClient().unsubscribe(url, sid: sid);
  final result = GENASubscribeResult.formResponse(response);
}
