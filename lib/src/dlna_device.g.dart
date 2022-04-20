// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dlna_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DLNADevice _$DLNADeviceFromJson(Map<String, dynamic> json) => DLNADevice(
      usn: json['usn'] as String,
      location: json['location'] as String,
    )
      ..expirationTime = json['expirationTime'] as int
      ..detail = json['detail'] == null
          ? null
          : DLNADeviceDetail.fromJson(json['detail'] as Map<String, dynamic>);

Map<String, dynamic> _$DLNADeviceToJson(DLNADevice instance) =>
    <String, dynamic>{
      'usn': instance.usn,
      'location': instance.location,
      'expirationTime': instance.expirationTime,
      'detail': instance.detail?.toJson(),
    };

DLNADeviceDetail _$DLNADeviceDetailFromJson(Map<String, dynamic> json) =>
    DLNADeviceDetail(
      json['deviceType'] as String? ?? '',
      json['friendlyName'] as String? ?? '',
      json['UDN'] as String,
      json['manufacturer'] as String? ?? '',
      json['manufacturerURL'] as String? ?? '',
      json['modelURL'] as String? ?? '',
      json['modelName'] as String? ?? '',
      json['modelDescription'] as String? ?? '',
    )..serviceList =
        parseDLNAService(json['serviceList'] as Map<String, dynamic>);

Map<String, dynamic> _$DLNADeviceDetailToJson(DLNADeviceDetail instance) =>
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
