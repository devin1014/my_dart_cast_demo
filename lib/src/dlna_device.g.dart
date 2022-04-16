// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dlna_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DLNADevice _$DLNADeviceFromJson(Map<String, dynamic> json) => DLNADevice(
      usn: json['usn'] as String,
      uuid: json['uuid'] as String,
      location: json['location'] as String,
    )..detail = json['detail'] == null ? null : DLNADeviceDetail.fromJson(json['detail'] as Map<String, dynamic>);

Map<String, dynamic> _$DLNADeviceToJson(DLNADevice instance) => <String, dynamic>{
      'usn': instance.usn,
      'uuid': instance.uuid,
      'location': instance.location,
      'detail': instance.detail?.toJson(),
    };

DLNADeviceDetail _$DLNADeviceDetailFromJson(Map<String, dynamic> json) => DLNADeviceDetail(
      json['deviceType'] as String? ?? '',
      json['friendlyName'] as String? ?? '',
      json['UDN'] as String,
      json['manufacturer'] as String? ?? '',
      json['manufacturerURL'] as String? ?? '',
      json['modelURL'] as String? ?? '',
      json['modelName'] as String? ?? '',
      json['modelDescription'] as String? ?? '',
    )
      ..baseURL = json['URLBase'] as String? ?? ''
      ..serviceList = parseDLNAService(json['serviceList'] as Map<String, dynamic>);

Map<String, dynamic> _$DLNADeviceDetailToJson(DLNADeviceDetail instance) => <String, dynamic>{
      'deviceType': instance.deviceType,
      'friendlyName': instance.friendlyName,
      'UDN': instance.udn,
      'manufacturer': instance.manufacturer,
      'manufacturerURL': instance.manufacturerURL,
      'modelDescription': instance.modelDescription,
      'modelName': instance.modelName,
      'modelURL': instance.modelURL,
      'URLBase': instance.baseURL,
      'serviceList': instance.serviceList.map((e) => e.toJson()).toList(),
    };

DLNAService _$DLNAServiceFromJson(Map<String, dynamic> json) => DLNAService(
      type: json['serviceType'] as String? ?? '',
      serviceId: json['serviceId'] as String? ?? '',
      scpdUrl: json['SCPDURL'] as String? ?? '',
      controlUrl: json['controlURL'] as String? ?? '',
      eventSubUrl: json['eventSubURL'] as String? ?? '',
    )..actionList = (readServiceAction(json, 'actionList') as List<dynamic>?)
        ?.map((e) => DLNAServiceAction.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$DLNAServiceToJson(DLNAService instance) => <String, dynamic>{
      'serviceType': instance.type,
      'serviceId': instance.serviceId,
      'SCPDURL': instance.scpdUrl,
      'controlURL': instance.controlUrl,
      'eventSubURL': instance.eventSubUrl,
      'actionList': instance.actionList?.map((e) => e.toJson()).toList(),
    };

DLNAServiceAction _$DLNAServiceActionFromJson(Map<String, dynamic> json) => DLNAServiceAction(
      json['name'] as String,
      parseActionArgument(readActionArgument(json, 'argument')),
    );

Map<String, dynamic> _$DLNAServiceActionToJson(DLNAServiceAction instance) => <String, dynamic>{
      'name': instance.name,
      'argument': instance.argument.map((e) => e.toJson()).toList(),
    };

DLNAServiceActionArgument _$DLNAServiceActionArgumentFromJson(Map<String, dynamic> json) => DLNAServiceActionArgument(
      json['name'] as String,
      json['direction'] as String,
      json['relatedStateVariable'] as String,
    );

Map<String, dynamic> _$DLNAServiceActionArgumentToJson(DLNAServiceActionArgument instance) => <String, dynamic>{
      'name': instance.name,
      'direction': instance.direction,
      'relatedStateVariable': instance.relatedStateVariable,
    };
