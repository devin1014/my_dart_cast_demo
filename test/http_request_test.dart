import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_cast_demo/src/http/http_client.dart';

const url = "http://192.168.3.137:8082/dlna/callback";

void main() async {
  final httpClient = MyHttpClient();

  test("http server response", () async {
    final result = await httpClient.postUrl(url: url, header: {"t1": "1t"}, content: "this is post data!");
    expect(true, result.startsWith("OK"));
  });
}
