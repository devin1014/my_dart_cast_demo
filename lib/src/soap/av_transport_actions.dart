import 'package:my_dart_cast_demo/src/soap/service_actions.dart';

/// -------------------------------------------------------------
/// AvTransport Service
/// -------------------------------------------------------------
class GetCurrentTransportActions extends AbstractServiceAction {}

class GetTransportInfo extends AbstractServiceAction {}

class GetPositionInfo extends AbstractServiceAction {}

class GetMediaInfo extends AbstractServiceAction {}

class GetDeviceCapabilities extends AbstractServiceAction {}

class Next extends AbstractServiceAction {}

class Pause extends AbstractServiceAction {}

class Play extends AbstractServiceAction {}

class Previous extends AbstractServiceAction {}

class Seek extends AbstractServiceAction {}

class SetPlayMode extends AbstractServiceAction {}

class Stop extends AbstractServiceAction {}

class SetAVTransportURI extends AbstractServiceAction {
  static const String VIDEO_MP4 = 'http-get:*:video/mp4:*';

  @override
  String? getContent() {
    var time = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
    // var title = const HtmlEscape().convert(didlObject.title);
    // var url = const HtmlEscape().convert(didlObject.url);
    final title = "dlna cast title";
    final url = "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4";
    return """<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
<s:Body>
<u:SetAVTransportURI xmlns:u="urn:schemas-upnp-org:service:AVTransport:1">
<InstanceID>0</InstanceID>
<CurrentURI>$url</CurrentURI>
<CurrentURIMetaData>
  <DIDL-Lite xmlns="urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:upnp="urn:schemas-upnp-org:metadata-1-0/upnp/" xmlns:dlna="urn:schemas-dlna-org:metadata-1-0/">
	  <item id="id" parentID="0" restricted="0">
		  <dc:title>$title</dc:title>
		  <upnp:artist>unknow</upnp:artist>
      <upnp:class>object.item.videoItem</upnp:class>
		  <dc:date>$time</dc:date>
		  <res protocolInfo="$VIDEO_MP4}">$url</res>
	  </item>
  </DIDL-Lite>
</CurrentURIMetaData>
</u:SetAVTransportURI>
</s:Body>
</s:Envelope>""";
  }
}
