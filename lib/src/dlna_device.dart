import 'package:json_annotation/json_annotation.dart';
import 'package:my_dart_cast_demo/src/parser.dart';

part 'dlna_device.g.dart';

/// DLNA Device
@JsonSerializable(explicitToJson: true)
class DLNADevice {
  final String usn;
  final String uuid;
  String location;
  @JsonKey(ignore: true)
  int cacheControl = 300;
  DLNADeviceDetail? detail;

  @JsonKey(ignore: true)
  bool isFromCache = false;
  @JsonKey(ignore: true)
  int aliveTime = 0;
  @JsonKey(ignore: true)
  int expirationTime = 0;
  @JsonKey(ignore: true)
  int lastDescriptionTime = 0;
  @JsonKey(ignore: true)
  int discoveryFromStartSpendingTime = 0;
  @JsonKey(ignore: true)
  int descriptionTaskSpendingTime = 0;

  DLNADevice({required this.usn, required this.uuid, required this.location});

  factory DLNADevice.fromJson(Map<String, dynamic> json) => _$DLNADeviceFromJson(json);

  Map<String, dynamic> toJson() => _$DLNADeviceToJson(this);

  set setCacheControl(int time) {
    cacheControl = time;
    aliveTime = DateTime.now().millisecondsSinceEpoch;
    expirationTime = aliveTime + time * 1000;
  }

  String get deviceName => detail?.friendlyName ?? "";

  bool get isXiaoMiDevice => detail?.manufacturer.toLowerCase().contains("xiaomi") ?? false;

  @override
  int get hashCode => uuid.hashCode;

  @override
  bool operator ==(other) {
    if (other is DLNADevice) {
      return uuid == other.uuid;
    }
    return super == other;
  }
}

/// DLNA Description
@JsonSerializable(explicitToJson: true)
class DLNADeviceDetail {
  String deviceType = "";
  String friendlyName = "";
  @JsonKey(name: "UDN")
  String udn = "";
  String manufacturer = "";
  String manufacturerURL = "";
  String modelDescription = "";
  String modelName = "";
  String modelURL = "";
  @JsonKey(name: "URLBase", defaultValue: "")
  String baseURL = "";

  @JsonKey(fromJson: parseDLNAService)
  List<DLNAService> serviceList = [];

  @JsonKey(ignore: true)
  String? _avTransportControlURL;

  String get avTransportControlURL {
    _avTransportControlURL ??= _findServiceControlUrl(serviceList, DlnaParser.AV_TRANSPORT);
    return _avTransportControlURL ?? "";
  }

  @JsonKey(ignore: true)
  String? _renderingControlControlURL;

  String get renderingControlControlURL {
    _renderingControlControlURL ??= _findServiceControlUrl(serviceList, DlnaParser.RENDERING_CONTROL);
    return _renderingControlControlURL ?? "";
  }

  @JsonKey(ignore: true)
  String? _connectionManagerControlURL;

  String get connectionManagerControlURL {
    _connectionManagerControlURL ??= _findServiceControlUrl(serviceList, DlnaParser.CONNECTION_MANAGER);
    return _connectionManagerControlURL ?? "";
  }

  DLNADeviceDetail();

  factory DLNADeviceDetail.fromJson(Map<String, dynamic> json) => _$DLNADeviceDetailFromJson(json);

  Map<String, dynamic> toJson() => _$DLNADeviceDetailToJson(this);
}

List<DLNAService> parseDLNAService(Map<String, dynamic> json) {
  List<dynamic> services = json["service"];
  return services.map((e) => DLNAService.fromJson(e as Map<String, dynamic>)).toList();
}

String _findServiceControlUrl(List<DLNAService> list, String type) {
  final result = list.where((element) => type == element.type);
  if (result.isNotEmpty) {
    return result.first.controlUrl;
  } else {
    return "";
  }
}

/// DLNA Service
@JsonSerializable(explicitToJson: true)
class DLNAService {
  @JsonKey(name: "serviceType", defaultValue: "")
  final String type;
  @JsonKey(defaultValue: "")
  final String serviceId;
  @JsonKey(name: "SCPDURL", defaultValue: "")
  final String scpdUrl;
  @JsonKey(name: "controlURL", defaultValue: "")
  final String controlUrl;
  @JsonKey(name: "eventSubURL", defaultValue: "")
  final String eventSubUrl;
  @JsonKey(readValue: readServiceAction)
  List<DLNAServiceAction>? actionList;

  DLNAService({
    required this.type,
    required this.serviceId,
    required this.scpdUrl,
    required this.controlUrl,
    required this.eventSubUrl,
  });

  factory DLNAService.fromJson(Map<String, dynamic> json) => _$DLNAServiceFromJson(json);

  Map<String, dynamic> toJson() => _$DLNAServiceToJson(this);
}

Object? readServiceAction(Map<dynamic, dynamic> json, String key) {
  if (json.containsKey("scpd")) {
    return json["scpd"]["actionList"]["action"];
  } else {
    return null;
  }
}

/// DLNA Service Action
@JsonSerializable(explicitToJson: true)
class DLNAServiceAction {
  final String name;
  @JsonKey(readValue: readActionArgument, fromJson: parseActionArgument)
  final List<DLNAServiceActionArgument> argument;

  DLNAServiceAction(this.name, this.argument);

  factory DLNAServiceAction.fromJson(Map<String, dynamic> json) => _$DLNAServiceActionFromJson(json);

  Map<String, dynamic> toJson() => _$DLNAServiceActionToJson(this);
}

Object? readActionArgument(Map<dynamic, dynamic> json, String key) {
  if (json.containsKey("argumentList")) {
    return json["argumentList"]["argument"];
  } else {
    return null;
  }
}

List<DLNAServiceActionArgument> parseActionArgument(dynamic argument) {
  if (argument is Map<String, dynamic>) {
    return [DLNAServiceActionArgument.fromJson(argument)];
  } else if (argument is List) {
    return argument.map((e) => DLNAServiceActionArgument.fromJson(e as Map<String, dynamic>)).toList(growable: false);
  } else {
    return [];
  }
}

/// DLNA Service Action
@JsonSerializable(explicitToJson: true)
class DLNAServiceActionArgument {
  final String name;
  final String direction;
  final String relatedStateVariable;

  DLNAServiceActionArgument(this.name, this.direction, this.relatedStateVariable);

  factory DLNAServiceActionArgument.fromJson(Map<String, dynamic> json) => _$DLNAServiceActionArgumentFromJson(json);

  Map<String, dynamic> toJson() => _$DLNAServiceActionArgumentToJson(this);
}
