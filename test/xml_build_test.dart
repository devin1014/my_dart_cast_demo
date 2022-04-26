// ignore_for_file: avoid_print

import 'package:xml/xml.dart';

const envelopeData = """<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
	<s:Body>
		<u:TargetAction xmlns:u="serviceType">
		</u:TargetAction>
	</s:Body>
</s:Envelope>""";

const didlLite = """
<DIDL-Lite xmlns="urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:upnp="urn:schemas-upnp-org:metadata-1-0/upnp/" xmlns:dlna="urn:schemas-dlna-org:metadata-1-0/">
<item id="id" parentID="0" restricted="0">
<dc:title>title</dc:title>
<upnp:artist>artist</upnp:artist>
<upnp:class>clazz</upnp:class>
<dc:date>date</dc:date>
<res protocolInfo="video/mp4">url</res>
</item>
</DIDL-Lite>
""";

const parse = false;

void main() {
  XmlDocument document = buildEnvelopeXml();
  // XmlDocument document = buildDidlLite();
  print(document.toXmlString(pretty: true, indent: '\t'));
}

XmlDocument buildEnvelopeXml() {
  final itemData = buildDidlLite().toXmlString(pretty: true);
  final builder = XmlBuilder();
  builder.declaration(version: "1", encoding: "utf-8", attributes: {"standalone": "yes"});
  builder.element(
    "s:Envelope",
    attributes: {
      "s:encodingStyle": "http://schemas.xmlsoap.org/soap/encoding/",
      "xmlns": "http://schemas.xmlsoap.org/soap/envelope/"
    },
    nest: () {
      builder.element("s:Body", nest: () {
        builder.xml(itemData);
        // builder.element("Item", nest: itemData);
      });
    },
  );
  return builder.buildDocument();
}

XmlDocument buildDidlLite() {
  final builder = XmlBuilder();
  builder.element(
    "DIDL-Lite",
    attributes: {
      "xmlns": "urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/",
      "xmlns:upnp": "urn:schemas-upnp-org:metadata-1-0/upnp/",
      "xmlns:dlna": "urn:schemas-dlna-org:metadata-1-0/",
      "xmlns:dc": "http://purl.org/dc/elements/1.1/"
    },
    nest: () {
      builder.element(
        "item",
        attributes: {"id": "id", "parentID": "0", "restricted": "0"},
        nest: () {
          builder.element("dc:title", nest: "title");
          builder.element("dc:artist", nest: "artist");
          builder.element("dc:class", nest: "clazz");
          builder.element("dc:date", nest: "date");
          builder.element("res", attributes: {"protocolInfo": "video/mp4"}, nest: "url");
        },
      );
    },
  );
  return builder.buildDocument();
}
