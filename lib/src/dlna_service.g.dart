// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dlna_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DLNAService _$DLNAServiceFromJson(Map<String, dynamic> json) => DLNAService(
      type: json['serviceType'] as String? ?? '',
      serviceId: json['serviceId'] as String? ?? '',
      scpdUrl: json['SCPDURL'] as String? ?? '',
      controlUrl: json['controlURL'] as String? ?? '',
      eventSubUrl: json['eventSubURL'] as String? ?? '',
    )..actionList = (readServiceAction(json, 'actionList') as List<dynamic>?)
        ?.map((e) => DLNAServiceAction.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$DLNAServiceToJson(DLNAService instance) =>
    <String, dynamic>{
      'serviceType': instance.type,
      'serviceId': instance.serviceId,
      'SCPDURL': instance.scpdUrl,
      'controlURL': instance.controlUrl,
      'eventSubURL': instance.eventSubUrl,
      'actionList': instance.actionList?.map((e) => e.toJson()).toList(),
    };

DLNAServiceAction _$DLNAServiceActionFromJson(Map<String, dynamic> json) =>
    DLNAServiceAction(
      json['name'] as String,
      parseActionArgument(readActionArgument(json, 'argument')),
    );

Map<String, dynamic> _$DLNAServiceActionToJson(DLNAServiceAction instance) =>
    <String, dynamic>{
      'name': instance.name,
      'argument': instance.argument.map((e) => e.toJson()).toList(),
    };

DLNAServiceActionArgument _$DLNAServiceActionArgumentFromJson(
        Map<String, dynamic> json) =>
    DLNAServiceActionArgument(
      json['name'] as String,
      json['direction'] as String,
      json['relatedStateVariable'] as String,
    );

Map<String, dynamic> _$DLNAServiceActionArgumentToJson(
        DLNAServiceActionArgument instance) =>
    <String, dynamic>{
      'name': instance.name,
      'direction': instance.direction,
      'relatedStateVariable': instance.relatedStateVariable,
    };
