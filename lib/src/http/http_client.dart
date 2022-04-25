// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

class MyHttpClient {
  static MyHttpClient? _instance;

  factory MyHttpClient() => _instance ??= MyHttpClient._();

  MyHttpClient._() {
    _httpClient
      ..idleTimeout = const Duration(seconds: 5)
      ..connectionTimeout = const Duration(seconds: 5);
  }

  bool logging = true;
  final HttpClient _httpClient = HttpClient();

  HttpClient get httpClient => _httpClient;

  Future<String> getUrl(String url) async {
    final request = await _httpClient.getUrl(Uri.parse(url));
    printRequest(request);
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    printResponse(response, body);
    return body;
  }

  Future<String> postUrl({
    required String url,
    Map<String, String>? header,
    String? content,
  }) async {
    final request = await _httpClient.postUrl(Uri.parse(url))
      ..headers.contentType = ContentType('text', 'xml', charset: 'utf-8')
      ..headers.contentLength = content == null ? 0 : utf8.encode(content).length
      ..headers.add('Connection', 'Keep-Alive')
      ..headers.add('Charset', 'UTF-8');
    if (header?.isNotEmpty == true) {
      header!.forEach((key, value) {
        request.headers.add(key, value);
      });
    }
    request.write(content);
    printRequest(request);
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    printResponse(response, body);
    return body;
  }

  void printRequest(HttpClientRequest request) {
    if (!logging) return;
    print("\nrequest:\n${request.method} ${request.uri}");
    print("headers:\n${request.headers.toString()}");
    // final data =  utf8.decoder.bind(request).join();
    print("cookie:\n${request.cookies.toString()}");
  }

  void printResponse(HttpClientResponse response, String body) async {
    if (!logging) return;
    print("\nresponse:\n${response.statusCode} ${response.reasonPhrase}");
    print("headers:\n${response.headers.toString()}");
    print("cookie:\n${response.cookies.toString()}");
    print("body:\n$body");
  }
}
