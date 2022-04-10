import 'package:json_annotation/json_annotation.dart';
import 'package:my_dart_cast_demo/src/ssdp/description_parser.dart';

part 'dlna_device.g.dart';

/// DLNA Device
class DLNADevice {
  final String usn;
  final String uuid;
  final String location;
  int cacheControl = 300;
  DLNADescription? description;

  bool isFromCache = false;
  int aliveTime = 0;
  int expirationTime = 0;
  int lastDescriptionTime = 0;
  int discoveryFromStartSpendingTime = 0;
  int descriptionTaskSpendingTime = 0;

  DLNADevice({required this.usn, required this.uuid, required this.location});

  set setCacheControl(int time) {
    cacheControl = time;
    aliveTime = DateTime.now().millisecondsSinceEpoch;
    expirationTime = aliveTime + time * 1000;
  }

  String get deviceName => description?.friendlyName ?? "";

  bool get isXiaoMiDevice => description?.manufacturer.toLowerCase().contains("xiaomi") ?? false;

  @override
  int get hashCode => uuid.hashCode;

  @override
  bool operator ==(other) {
    if (other is DLNADevice) {
      return uuid == other.uuid;
    }
    return super == other;
  }

  Map toJson() {
    Map map = {};
    map["usn"] = usn;
    map["uuid"] = uuid;
    map["location"] = location;
    map["deviceName"] = deviceName;
    return map;
  }

  String _time2Str(int intTime) {
    var time = DateTime.fromMillisecondsSinceEpoch(intTime);
    return "${time.year.toString()}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
  }
}

/// DLNA Description
@JsonSerializable(explicitToJson: true)
class DLNADescription {
  String deviceType = "";
  String friendlyName = "";
  @JsonKey(name: "UDN")
  String udn = "";
  String manufacturer = "";
  String manufacturerURL = "";
  String modelDescription = "";
  String modelName = "";
  String modelURL = "";

  @JsonKey(fromJson: parseDLNAService)
  List<DLNAService> serviceList = [];

  @JsonKey(ignore: true)
  String? _avTransportControlURL;

  String get avTransportControlURL {
    _avTransportControlURL ??= _findServiceControlUrl(serviceList, DescriptionParser.AV_TRANSPORT);
    return _avTransportControlURL ?? "";
  }

  @JsonKey(ignore: true)
  String? _renderingControlControlURL;

  String get renderingControlControlURL {
    _renderingControlControlURL ??= _findServiceControlUrl(serviceList, DescriptionParser.RENDERING_CONTROL);
    return _renderingControlControlURL ?? "";
  }

  @JsonKey(ignore: true)
  String? _connectionManagerControlURL = "";

  String get connectionManagerControlURL {
    _connectionManagerControlURL ??= _findServiceControlUrl(serviceList, DescriptionParser.CONNECTION_MANAGER);
    return _connectionManagerControlURL ?? "";
  }

  DLNADescription();

  factory DLNADescription.fromJson(Map<String, dynamic> json) => _$DLNADescriptionFromJson(json);

  Map<String, dynamic> toJson() => _$DLNADescriptionToJson(this);
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
