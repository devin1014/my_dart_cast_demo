// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dlna_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DLNADevice _$DLNADeviceFromJson(Map<String, dynamic> json) => DLNADevice(
      usn: json['usn'] as String,
      uuid: json['uuid'] as String,
      location: json['location'] as String,
    )..description = json['description'] == null
        ? null
        : DLNADescription.fromJson(json['description'] as Map<String, dynamic>);

Map<String, dynamic> _$DLNADeviceToJson(DLNADevice instance) =>
    <String, dynamic>{
      'usn': instance.usn,
      'uuid': instance.uuid,
      'location': instance.location,
      'description': instance.description?.toJson(),
    };

DLNADescription _$DLNADescriptionFromJson(Map<String, dynamic> json) =>
    DLNADescription()
      ..deviceType = json['deviceType'] as String
      ..friendlyName = json['friendlyName'] as String
      ..udn = json['UDN'] as String
      ..manufacturer = json['manufacturer'] as String
      ..manufacturerURL = json['manufacturerURL'] as String
      ..modelDescription = json['modelDescription'] as String
      ..modelName = json['modelName'] as String
      ..modelURL = json['modelURL'] as String
      ..serviceList =
          parseDLNAService(json['serviceList'] as Map<String, dynamic>);

Map<String, dynamic> _$DLNADescriptionToJson(DLNADescription instance) =>
    <String, dynamic>{
      'deviceType': instance.deviceType,
      'friendlyName': instance.friendlyName,
      'UDN': instance.udn,
      'manufacturer': instance.manufacturer,
      'manufacturerURL': instance.manufacturerURL,
      'modelDescription': instance.modelDescription,
      'modelName': instance.modelName,
      'modelURL': instance.modelURL,
      'serviceList': instance.serviceList.map((e) => e.toJson()).toList(),
    };

DLNAService _$DLNAServiceFromJson(Map<String, dynamic> json) => DLNAService(
      type: json['serviceType'] as String? ?? '',
      serviceId: json['serviceId'] as String? ?? '',
      scpdUrl: json['SCPDURL'] as String? ?? '',
      controlUrl: json['controlURL'] as String? ?? '',
      eventSubUrl: json['eventSubURL'] as String? ?? '',
    );

Map<String, dynamic> _$DLNAServiceToJson(DLNAService instance) =>
    <String, dynamic>{
      'serviceType': instance.type,
      'serviceId': instance.serviceId,
      'SCPDURL': instance.scpdUrl,
      'controlURL': instance.controlUrl,
      'eventSubURL': instance.eventSubUrl,
    };
