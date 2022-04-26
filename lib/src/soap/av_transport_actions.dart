import 'package:my_dart_cast_demo/src/dlna_service.dart';
import 'package:my_dart_cast_demo/src/parser.dart';
import 'package:my_dart_cast_demo/src/soap/didl_object.dart';
import 'package:my_dart_cast_demo/src/soap/service_actions.dart';

import 'action_result.dart';

/// -------------------------------------------------------------
/// AvTransport Service
/// -------------------------------------------------------------
class GetCurrentTransportActions extends AbstractServiceAction {
  GetCurrentTransportActions(DLNAService service) : super(service);
}

class GetTransportSettings extends AbstractServiceAction {
  GetTransportSettings(DLNAService service) : super(service);
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
  Play(DLNAService service, {this.speed = 1}) : super(service);

  final double speed;

  @override
  List<ServiceActionArgument> getSoapActionArgument() => [
        ServiceActionArgument("InstanceID", 0),
        ServiceActionArgument("Speed", speed),
      ];
}

class Previous extends AbstractServiceAction {
  Previous(DLNAService service) : super(service);
}

/// @param realPosition: second
class Seek extends AbstractServiceAction {
  Seek(DLNAService service, {this.realPosition = -1}) : super(service);

  final int realPosition;

  @override
  List<ServiceActionArgument> getSoapActionArgument() => [
        ServiceActionArgument("InstanceID", 0),
        ServiceActionArgument("Unit", "REL_TIME"),
        ServiceActionArgument("Target", DlnaParser.formatRealTime(realPosition)),
      ];
}

class SetPlayMode extends AbstractServiceAction {
  SetPlayMode(DLNAService service, {this.mode = PlayMode.NORMAL}) : super(service);

  final PlayMode mode;

  @override
  List<ServiceActionArgument> getSoapActionArgument() => [
        ServiceActionArgument("InstanceID", 0),
        ServiceActionArgument("CurrentPlayMode", mode),
      ];
}

class Stop extends AbstractServiceAction {
  Stop(DLNAService service) : super(service);
}

class SetAVTransportURI extends AbstractServiceAction {
  SetAVTransportURI(DLNAService service, this.didlObject) : super(service);

  final DIDLObject didlObject;

  @override
  List<ServiceActionArgument> getSoapActionArgument() => [
        ServiceActionArgument("InstanceID", 0),
        ServiceActionArgument("CurrentURI", didlObject.url),
        ServiceActionArgument("CurrentURIMetaData", didlObject.xmlData, isXmlData: true),
      ];
}

//TODO: nextURI failed.
class SetNextAVTransportURI extends AbstractServiceAction {
  SetNextAVTransportURI(DLNAService service, this.didlObject) : super(service);

  final DIDLObject didlObject;

  @override
  List<ServiceActionArgument> getSoapActionArgument() => [
        ServiceActionArgument("InstanceID", 0),
        ServiceActionArgument("NextURI", didlObject.url),
        ServiceActionArgument("NextURIMetaData", didlObject.xmlData, isXmlData: true),
      ];
}
