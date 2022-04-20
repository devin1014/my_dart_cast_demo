import 'package:json_annotation/json_annotation.dart';

part 'dlna_service.g.dart';

/// ------------------------------------------------
/// DLNA Service
/// ------------------------------------------------
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
  @JsonKey(ignore: true)
  String baseUrl = "";

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

// mixin DLNAServiceManager on DLNAService {
//   Future<dynamic> execute(AbstractServiceAction action) async {
//     final url = baseUrl + "/" + controlUrl;
//     final response = await MyHttpClient().postUrl(
//       url: url,
//       header: action.getHeader() ?? {"SoapAction": '"$type#${action.getSoapAction()}"'},
//       content: action.getContent() ?? action.parseXmlData(this),
//     );
//     return action.parseResult(response);
//   }
// }

/// ------------------------------------------------
/// DLNA Service Action
/// ------------------------------------------------
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

/// ------------------------------------------------
/// DLNA Service Action
/// ------------------------------------------------
@JsonSerializable(explicitToJson: true)
class DLNAServiceActionArgument {
  final String name;
  final String direction;
  final String relatedStateVariable;

  DLNAServiceActionArgument(this.name, this.direction, this.relatedStateVariable);

  factory DLNAServiceActionArgument.fromJson(Map<String, dynamic> json) => _$DLNAServiceActionArgumentFromJson(json);

  Map<String, dynamic> toJson() => _$DLNAServiceActionArgumentToJson(this);
}
