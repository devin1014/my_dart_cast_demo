import 'dart:convert';
import 'dart:io';

import 'package:my_dart_cast_demo/src/http/http_client.dart';

extension GENAHttpService on MyHttpClient {
  Future<HttpClientResponse> subscribe(String url, {required String callbackUrl}) async {
    return _subscribe(true, url, callbackUrl: callbackUrl);
  }

  Future<HttpClientResponse> resubscribe(String url, {required String sid}) async {
    return _subscribe(true, url, sid: sid);
  }

  Future<HttpClientResponse> unsubscribe(String url, {required String sid}) async {
    return _subscribe(false, url, sid: sid);
  }

  Future<HttpClientResponse> _subscribe(bool subscribe, String url, {String? callbackUrl, String? sid}) async {
    final uri = Uri.parse(url);
    final HttpClientRequest request =
        await httpClient.open(subscribe ? "SUBSCRIBE" : "UNSUBSCRIBE", uri.host, uri.port, uri.path);
    final headers = request.headers;
    if (callbackUrl?.isNotEmpty == true) {
      headers.add("TIMEOUT", "Second-3600");
      headers.add("NT", "upnp:event");
      headers.add("CALLBACK", "<$callbackUrl>");
    } else if (sid?.isNotEmpty == true) {
      headers.add("TIMEOUT", "Second-3600");
      headers.add("SID", sid!);
    }
    printRequest(request);
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    printResponse(response, body);
    return response;
  }
}
