import 'package:my_dart_cast_demo/src/dlna_service.dart';
import 'package:my_dart_cast_demo/src/soap/service_actions.dart';

import 'action_result.dart';

/// -------------------------------------------------------------
/// AvTransport Service
/// -------------------------------------------------------------
class GetCurrentTransportActions extends AbstractServiceAction {
  GetCurrentTransportActions(DLNAService service) : super(service);
}

class GetTransportInfo extends AbstractServiceAction {
  GetTransportInfo(DLNAService service) : super(service);

  @override
  parseResult(Map<String, dynamic> response) {
    final json = response["s:Envelope"]["s:Body"]["u:GetTransportInfoResponse"];
    return GetTransportInfoResponse.fromJson(json);
  }
}

class GetPositionInfo extends AbstractServiceAction {
  GetPositionInfo(DLNAService service) : super(service);

  @override
  parseResult(Map<String, dynamic> response) {
    final json = response["s:Envelope"]["s:Body"]["u:GetPositionInfoResponse"];
    return GetPositionInfoResponse.fromJson(json);
  }
}

class GetMediaInfo extends AbstractServiceAction {
  GetMediaInfo(DLNAService service) : super(service);

  @override
  parseResult(Map<String, dynamic> response) {
    final json = response["s:Envelope"]["s:Body"]["u:GetMediaInfoResponse"];
    return GetMediaInfoResponse.fromJson(json);
  }
}

class GetDeviceCapabilities extends AbstractServiceAction {
  GetDeviceCapabilities(DLNAService service) : super(service);
}

class Next extends AbstractServiceAction {
  Next(DLNAService service) : super(service);
}

class Pause extends AbstractServiceAction {
  Pause(DLNAService service) : super(service);
}

class Play extends AbstractServiceAction {
  Play(DLNAService service) : super(service);
}

class Previous extends AbstractServiceAction {
  Previous(DLNAService service) : super(service);
}

class Seek extends AbstractServiceAction {
  Seek(DLNAService service) : super(service);
}

class SetPlayMode extends AbstractServiceAction {
  SetPlayMode(DLNAService service) : super(service);
}

class Stop extends AbstractServiceAction {
  Stop(DLNAService service) : super(service);
}

class SetAVTransportURI extends AbstractServiceAction {
  static const String VIDEO_MP4 = 'http-get:*:video/mp4:*';

  SetAVTransportURI(DLNAService service) : super(service);

  @override
  String? getContent() {
    var time = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
    // var title = const HtmlEscape().convert(didlObject.title);
    // var url = const HtmlEscape().convert(didlObject.url);
    final title = "dlna cast title";
    final url = "http://vfx.mtime.cn/Video/2019/03/19/mp4/190319212559089721.mp4";
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
