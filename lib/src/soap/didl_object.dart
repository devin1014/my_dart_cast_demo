// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:xml/xml.dart';

abstract class DIDLObject {
  static const Map<String, String> _objectAttribute = {
    "xmlns": "urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/",
    "xmlns:upnp": "urn:schemas-upnp-org:metadata-1-0/upnp/",
    "xmlns:dlna": "urn:schemas-dlna-org:metadata-1-0/",
    "xmlns:dc": "http://purl.org/dc/elements/1.1/"
  };
  static const Map<String, String> _itemAttribute = {"id": "id", "parentID": "0", "restricted": "0"};
  static const String _PROTOCOL_INFO_TYPE = 'http-get:*:{type}:*';

  DIDLObject(
    this.url, {
    String title = "",
    String artist = "unknown",
    String clazz = "object.item.videoItem",
    String contentType = "*/*",
    String? xmlContent,
  }) {
    const htmlEscape = HtmlEscape();
    _xmlData = xmlContent ??
        _buildDidlLite(
          htmlEscape.convert(url),
          htmlEscape.convert(title),
          htmlEscape.convert(artist),
          htmlEscape.convert(clazz),
          DateTime.now().toString(),
          _PROTOCOL_INFO_TYPE.replaceFirst("{type}", contentType),
        ).toString();
  }

  final String url;

  String _xmlData = "";

  String get xmlData => _xmlData;

  XmlDocument _buildDidlLite(
    String url,
    String title,
    String artist,
    String clazz,
    String date,
    String protocolInfo,
  ) {
    final builder = XmlBuilder();
    builder.element(
      "DIDL-Lite",
      attributes: _objectAttribute,
      nest: () {
        builder.element(
          "item",
          attributes: _itemAttribute,
          nest: () {
            builder.element("dc:title", nest: title);
            builder.element("dc:artist", nest: artist);
            builder.element("dc:class", nest: clazz);
            builder.element("dc:date", nest: date);
            builder.element("res", attributes: {"protocolInfo": htmlEscape.convert(protocolInfo)}, nest: url);
          },
        );
      },
    );
    return builder.buildDocument();
  }
}

class DIDLVideoObject extends DIDLObject {
  DIDLVideoObject(String url) : super(url, contentType: "video/*");
}

class DIDLAudioObject extends DIDLObject {
  DIDLAudioObject(String url) : super(url, contentType: "audio/*");
}

class DIDLImageObject extends DIDLObject {
  DIDLImageObject(String url) : super(url, contentType: "image/*");
}
