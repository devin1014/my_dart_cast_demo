// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTransportInfoResponse _$GetTransportInfoResponseFromJson(
        Map<String, dynamic> json) =>
    GetTransportInfoResponse(
      json['CurrentTransportState'] as String? ?? '',
      json['CurrentTransportStatus'] as String? ?? '',
      (json['CurrentSpeed'] as String?) ?? "1",
    );

Map<String, dynamic> _$GetTransportInfoResponseToJson(
        GetTransportInfoResponse instance) =>
    <String, dynamic>{
      'CurrentTransportState': instance.currentTransportState,
      'CurrentTransportStatus': instance.currentTransportStatus,
      'CurrentSpeed': instance.currentSpeed,
    };

GetPositionInfoResponse _$GetPositionInfoResponseFromJson(
        Map<String, dynamic> json) =>
    GetPositionInfoResponse(
      json['Track'] as String? ?? '0',
      json['TrackDuration'] as String? ?? '',
      json['TrackMetaData'] as String? ?? '',
      json['TrackURI'] as String? ?? '',
      json['RelTime'] as String? ?? '',
      json['AbsTime'] as String? ?? '',
      json['RelCount'] as String? ?? '',
      json['AbsCount'] as String? ?? '',
    );

Map<String, dynamic> _$GetPositionInfoResponseToJson(
        GetPositionInfoResponse instance) =>
    <String, dynamic>{
      'Track': instance.track,
      'TrackDuration': instance.trackDuration,
      'TrackMetaData': instance.trackMetaData,
      'TrackURI': instance.trackURI,
      'RelTime': instance.relTime,
      'AbsTime': instance.absTime,
      'RelCount': instance.relCount,
      'AbsCount': instance.absCount,
    };

GetMediaInfoResponse _$GetMediaInfoResponseFromJson(
        Map<String, dynamic> json) =>
    GetMediaInfoResponse(
      json['NrTracks'] as String? ?? '0',
      json['MediaDuration'] as String? ?? '',
      json['CurrentURI'] as String? ?? '',
      json['CurrentURIMetaData'] as String? ?? '',
      json['NextURI'] as String? ?? '',
      json['NextURIMetaData'] as String? ?? '',
      json['PlayMedium'] as String? ?? '',
      json['RecordMedium'] as String? ?? '',
      json['WriteStatus'] as String? ?? '',
    );

Map<String, dynamic> _$GetMediaInfoResponseToJson(
        GetMediaInfoResponse instance) =>
    <String, dynamic>{
      'NrTracks': instance.nrTracks,
      'MediaDuration': instance.mediaDuration,
      'CurrentURI': instance.currentURI,
      'CurrentURIMetaData': instance.currentURIMetaData,
      'NextURI': instance.nextURI,
      'NextURIMetaData': instance.nextURIMetaData,
      'PlayMedium': instance.playMedium,
      'RecordMedium': instance.recordMedium,
      'WriteStatus': instance.writeStatus,
    };

GetProtocolInfoResponse _$GetProtocolInfoResponseFromJson(
        Map<String, dynamic> json) =>
    GetProtocolInfoResponse(
      json['Source'] as String? ?? '',
      json['Sink'] as String? ?? '',
    );

Map<String, dynamic> _$GetProtocolInfoResponseToJson(
        GetProtocolInfoResponse instance) =>
    <String, dynamic>{
      'Source': instance.source,
      'Sink': instance.sink,
    };
