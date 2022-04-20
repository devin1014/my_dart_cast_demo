import 'package:json_annotation/json_annotation.dart';
import 'package:my_dart_cast_demo/src/dlna_service.dart';

part 'dlna_device.g.dart';

/// ------------------------------------------------
/// DLNA Device
/// ------------------------------------------------
@JsonSerializable(explicitToJson: true)
class DLNADevice {
  final String usn;
  String location;
  int expirationTime = -1;

  DLNADeviceDetail? detail;

  @JsonKey(ignore: true)
  int lastDescriptionTime = 0;
  @JsonKey(ignore: true)
  int discoveryFromStartSpendingTime = 0;
  @JsonKey(ignore: true)
  bool alive = true;

  DLNADevice({required this.usn, required this.location, int cacheControl = 300}) {
    cacheTime = cacheControl;
  }

  factory DLNADevice.fromJson(Map<String, dynamic> json) => _$DLNADeviceFromJson(json);

  Map<String, dynamic> toJson() => _$DLNADeviceToJson(this);

  set cacheTime(int second) {
    if (second < 0) {
      expirationTime = -1;
    } else {
      expirationTime = DateTime.now().millisecondsSinceEpoch + second * 1000;
    }
  }

  bool get isExpired => expirationTime >= 0 && expirationTime < DateTime.now().millisecondsSinceEpoch;

  String get deviceName => detail?.friendlyName ?? "";

  @override
  int get hashCode => usn.hashCode;

  @override
  bool operator ==(other) {
    if (other is DLNADevice) {
      return usn == other.usn;
    }
    return super == other;
  }
}

/// ------------------------------------------------
/// DLNA Detail
/// ------------------------------------------------
@JsonSerializable(explicitToJson: true)
class DLNADeviceDetail {
  @JsonKey(defaultValue: "")
  final String deviceType;

  @JsonKey(defaultValue: "")
  final String friendlyName;

  @JsonKey(name: "UDN")
  final String udn;

  @JsonKey(defaultValue: "")
  final String manufacturer;

  @JsonKey(defaultValue: "")
  final String manufacturerURL;

  @JsonKey(defaultValue: "")
  final String modelDescription;

  @JsonKey(defaultValue: "")
  final String modelName;

  @JsonKey(defaultValue: "")
  final String modelURL;

  set baseUrl(String url) {
    for (var element in serviceList) {
      element.baseUrl = url;
    }
  }

  @JsonKey(fromJson: parseDLNAService)
  List<DLNAService> serviceList = [];

  DLNAService? getService(String serviceType) {
    try {
      return serviceList.firstWhere((element) => element.type == serviceType);
    } catch (e) {
      return null;
    }
  }

  DLNADeviceDetail(
    this.deviceType,
    this.friendlyName,
    this.udn,
    this.manufacturer,
    this.manufacturerURL,
    this.modelURL,
    this.modelName,
    this.modelDescription,
  );

  factory DLNADeviceDetail.fromJson(Map<String, dynamic> json) => _$DLNADeviceDetailFromJson(json);

  Map<String, dynamic> toJson() => _$DLNADeviceDetailToJson(this);
}

List<DLNAService> parseDLNAService(Map<String, dynamic> json) {
  List<dynamic> services;
  final result = json["service"];
  if (result is List) {
    services = result;
  } else if (result is Map) {
    services = [result];
  } else {
    throw Exception("can not parse 'service' element: $result");
  }
  return services.map((e) => DLNAService.fromJson(e as Map<String, dynamic>)).toList();
}
