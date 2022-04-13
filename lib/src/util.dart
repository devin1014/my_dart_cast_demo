import 'dart:convert';

import 'package:xml2json/xml2json.dart';

final Xml2Json _xml2json = Xml2Json();

dynamic parseXml2Json(String xml) {
  final xml2Json = _xml2json;
  xml2Json.parse(xml);
  String jsonStr = xml2Json.toParker();
  return jsonDecode(jsonStr);
}
