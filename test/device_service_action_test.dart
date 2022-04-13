// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:my_dart_cast_demo/src/http/http_client.dart';
import 'package:my_dart_cast_demo/src/soap/action_result.dart';
import 'package:xml2json/xml2json.dart';

const location = "http://192.168.3.119:49152/description.xml";
const connectionControlUrl = "_urn:schemas-upnp-org:service:ConnectionManager_control";
const avTransportControlUrl = "_urn:schemas-upnp-org:service:AVTransport_control";

void main() async {
  final result = await get(location, avTransportControlUrl);
  print("result: $result");
  parse(result.httpContent);
}

void parse(String httpContent) {
  try {
    final myTransformer = Xml2Json();
    myTransformer.parse(httpContent);
    String json = myTransformer.toParker();
    var value = jsonDecode(json)['s:Envelope']['s:Body'];
    // var value = jsonDecode(json)['s:Envelope']['s:Body']['u:GetProtocolInfoResponse'];
    print("value: $value");
  } catch (e) {
    print(e.toString());
  }
}

final HttpClient httpClient = HttpClient();
final ContentType contentType = ContentType('text', 'xml', charset: 'utf-8');

Future<ActionResult<dynamic>> get(String location, String controlUrl) async {
  final authority = Uri.parse(location).authority;
  final StringBuffer buffer = StringBuffer("http://");
  buffer.write(authority);
  if (!authority.endsWith("/")) {
    buffer.write("/");
  }
  if (controlUrl.startsWith('/')) {
    buffer.write(controlUrl.substring(1));
  } else {
    buffer.write(controlUrl);
  }
  final url = buffer.toString();
  try {
    final response = await MyHttpClient().postUrl(url, {"SoapAction": getSoapAction()}, getXmlData());
    return ActionResult.success(code: 200, httpContent: response);
  } catch (e) {
    return ActionResult.error(exception: e as Exception);
  }
}

String getSoapAction() {
  return '"urn:schemas-upnp-org:service:AVTransport:1#GetCurrentTransportActions"';
}

String getXmlData() {
  return """<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
	<s:Body>
		<u:GetCurrentTransportActions xmlns:u="urn:schemas-upnp-org:service:AVTransport:1">
			<InstanceID>0</InstanceID>
		</u:GetCurrentTransportActions>
	</s:Body>
</s:Envelope>""";
}
