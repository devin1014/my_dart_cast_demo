// ignore_for_file: constant_identifier_names

import 'dart:convert';

abstract class DIDLObject {
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
        _toXml(
          htmlEscape.convert(url),
          htmlEscape.convert(title),
          artist,
          clazz,
          DateTime.now().toString(),
          _PROTOCOL_INFO_TYPE.replaceFirst("{type}", contentType),
        );
  }

  final String url;

  String _xmlData = "";

  String get xmlData => _xmlData;

  String _toXml(String url, String title, String artist, String clazz, String date, String protocolInfo) {
    return """

<DIDL-Lite xmlns="urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:upnp="urn:schemas-upnp-org:metadata-1-0/upnp/" xmlns:dlna="urn:schemas-dlna-org:metadata-1-0/">
<item id="id" parentID="0" restricted="0">
<dc:title>$title</dc:title>
<upnp:artist>$artist</upnp:artist>
<upnp:class>$clazz</upnp:class>
<dc:date>$date</dc:date>
<res protocolInfo="$protocolInfo">$url</res>
</item>
</DIDL-Lite>

""";
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
