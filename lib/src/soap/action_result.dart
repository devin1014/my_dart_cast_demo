import 'package:json_annotation/json_annotation.dart';

part 'action_result.g.dart';

class ActionResult<T> {
  final int code;
  String httpContent;
  T? result;
  Exception? exception;

  ActionResult.success({required this.code, required this.httpContent}) : exception = null;

  ActionResult.error({this.code = -1, this.httpContent = "", required this.exception});

  bool get success => code >= 200 && code <= 299 && httpContent.isNotEmpty;

  @override
  String toString() => "ActionResult {code: $code, httpContent: $httpContent}";
}

abstract class ActionResponse {
  Map<String, dynamic> toJson();

  @override
  String toString() => toJson().toString();
}

@JsonSerializable(explicitToJson: true)
class GetTransportInfoResponse extends ActionResponse {
  @JsonKey(name: "CurrentTransportState", defaultValue: "")
  final String currentTransportState;
  @JsonKey(name: "CurrentTransportStatus", defaultValue: "")
  final String currentTransportStatus;
  @JsonKey(name: "CurrentSpeed", defaultValue: 1)
  final double currentSpeed;

  GetTransportInfoResponse(this.currentTransportState, this.currentTransportStatus, this.currentSpeed);

  factory GetTransportInfoResponse.fromJson(Map<String, dynamic> json) => _$GetTransportInfoResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetTransportInfoResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetPositionInfoResponse extends ActionResponse {
  @JsonKey(name: "Track", defaultValue: "0")
  final String track;
  @JsonKey(name: "TrackDuration", defaultValue: "")
  final String trackDuration;
  @JsonKey(name: "TrackMetaData", defaultValue: "")
  final String trackMetaData;
  @JsonKey(name: "TrackURI", defaultValue: "")
  final String trackURI;
  @JsonKey(name: "RelTime", defaultValue: "")
  final String relTime;
  @JsonKey(name: "AbsTime", defaultValue: "")
  final String absTime;
  @JsonKey(name: "RelCount", defaultValue: "")
  final String relCount;
  @JsonKey(name: "AbsCount", defaultValue: "")
  final String absCount;

  GetPositionInfoResponse(
    this.track,
    this.trackDuration,
    this.trackMetaData,
    this.trackURI,
    this.relTime,
    this.absTime,
    this.relCount,
    this.absCount,
  );

  factory GetPositionInfoResponse.fromJson(Map<String, dynamic> json) => _$GetPositionInfoResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetPositionInfoResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetMediaInfoResponse extends ActionResponse {
  @JsonKey(name: "NrTracks", defaultValue: "0")
  final String nrTracks;
  @JsonKey(name: "MediaDuration", defaultValue: "")
  final String mediaDuration;
  @JsonKey(name: "CurrentURI", defaultValue: "")
  final String currentURI;
  @JsonKey(name: "CurrentURIMetaData", defaultValue: "")
  final String currentURIMetaData;
  @JsonKey(name: "NextURI", defaultValue: "")
  final String nextURI;
  @JsonKey(name: "NextURIMetaData", defaultValue: "")
  final String nextURIMetaData;
  @JsonKey(name: "PlayMedium", defaultValue: "")
  final String playMedium;
  @JsonKey(name: "RecordMedium", defaultValue: "")
  final String recordMedium;
  @JsonKey(name: "WriteStatus", defaultValue: "")
  final String writeStatus;

  GetMediaInfoResponse(
    this.nrTracks,
    this.mediaDuration,
    this.currentURI,
    this.currentURIMetaData,
    this.nextURI,
    this.nextURIMetaData,
    this.playMedium,
    this.recordMedium,
    this.writeStatus,
  );

  factory GetMediaInfoResponse.fromJson(Map<String, dynamic> json) => _$GetMediaInfoResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetMediaInfoResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetProtocolInfoResponse extends ActionResponse {
  @JsonKey(name: "Source", defaultValue: "")
  final String source;
  @JsonKey(name: "Sink", defaultValue: "")
  final String sink;

  GetProtocolInfoResponse(this.source, this.sink);

  factory GetProtocolInfoResponse.fromJson(Map<String, dynamic> json) => _$GetProtocolInfoResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetProtocolInfoResponseToJson(this);
}
