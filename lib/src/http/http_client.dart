// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

class MyHttpClient {
  static MyHttpClient? _instance;

  factory MyHttpClient() => _instance ??= MyHttpClient._();

  MyHttpClient._() {
    print("HttpClient init.");
    _httpClient
      ..idleTimeout = const Duration(seconds: 5)
      ..connectionTimeout = const Duration(seconds: 5);
  }

  final HttpClient _httpClient = HttpClient();

  Future<String> getUrl(String url) async {
    final request = await _httpClient.getUrl(Uri.parse(url));
    final response = await request.close();
    return await response.transform(utf8.decoder).join();
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
    final response = await request.close();
    return await response.transform(utf8.decoder).join();
  }
}
