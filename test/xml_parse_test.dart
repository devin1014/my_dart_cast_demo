// ignore_for_file: avoid_print

import 'package:xml/xml.dart';

const bookshelfXml = '''<?xml version="1.0"?>
  <bookshelf>
    <book>
      <title lang="en">Growing a Language</title>
      <price>29.99</price>
    </book>
    <book>
      <title lang="en">Learning XML</title>
      <price>39.95</price>
    </book>
    <price>132.00</price>
  </bookshelf>
  ''';

const data = """<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
	<s:Body>
		<u:TargetAction xmlns:u="serviceType">
		</u:TargetAction>
	</s:Body>
</s:Envelope>
""";

const parse = false;

void main() {
  XmlDocument document = parseXml(bookshelfXml);
  print(document.toXmlString(pretty: true, indent: '\t'));
}

XmlDocument parseXml(String data) {
  return XmlDocument.parse(data);
}
