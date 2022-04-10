import 'dart:convert';
import 'dart:io';

class MyHttpClient {
  static MyHttpClient instance = MyHttpClient._();

  MyHttpClient._();

  factory MyHttpClient.get() {
    return instance;
  }

  final HttpClient _httpClient = HttpClient();

  Future<String> getUrl(String url) async {
    final request = await _httpClient.getUrl(Uri.parse(url));
    final response = await request.close();
    return await response.transform(utf8.decoder).join();
  }
}
