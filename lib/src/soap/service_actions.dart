// ignore_for_file: constant_identifier_names

import 'package:my_dart_cast_demo/src/dlna_service.dart';
import 'package:my_dart_cast_demo/src/http/http_client.dart';
import 'package:my_dart_cast_demo/src/parser.dart';
import 'package:my_dart_cast_demo/src/soap/action_result.dart';

abstract class AbstractServiceAction {
  AbstractServiceAction(this.service);

  final DLNAService service;

  Future<dynamic> execute() async {
    final url = service.baseUrl + "/" + service.controlUrl;
    final response = await MyHttpClient().postUrl(
      url: url,
      header: getHeader() ?? {"SoapAction": _parseAction(service)},
      content: getContent() ?? parseXmlData(service),
    );
    //TODO
    print(">>>>>>>>>>>>>>>>>>>>");
    print("request:\n\t$url");
    print("header:\n\t${{"SoapAction": _parseAction(service)}.toString()}");
    print("content:\n\t${parseXmlData(service)}");
    print("");
    print("<<<<<<<<<<<<<<<<<<<<");
    print("response:\n\t$response");
    final Map<String, dynamic> json = parseXml2Json(response);
    try {
      final fault = json["s:Envelope"]["s:Body"]["s:Fault"];
      return ActionFailedResponse.fromJson(fault);
    } catch (e) {
      return parseResult(json);
    }
  }

  Map<String, String>? getHeader() => null;

  String? getContent() => null;

  dynamic parseResult(Map<String, dynamic> response) => response;

  String _parseAction(DLNAService service) => '"${service.type}#${getSoapAction()}"';

  String getSoapAction() => runtimeType.toString();

  String parseXmlData(DLNAService service) => """<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
	<s:Body>
		<u:${getSoapAction()} xmlns:u="${service.type}">
			${_parseArguments()}
		</u:${getSoapAction()}>
	</s:Body>
</s:Envelope>""";

  String _parseArguments() {
    final List<ServiceActionArgument> arguments = getSoapActionArgument();
    StringBuffer buffer = StringBuffer();
    for (var arg in arguments) {
      if (buffer.isNotEmpty) buffer.write("\n");
      buffer.write("<${arg.name}>${arg.value}</${arg.name}>");
    }
    return buffer.toString();
  }

  static final List<ServiceActionArgument> _instanceIdArgument = [ServiceActionArgument("InstanceID", 0)];

  List<ServiceActionArgument> getSoapActionArgument() => _instanceIdArgument;
}

class ServiceActionArgument {
  final String name;
  final String value;

  ServiceActionArgument(this.name, dynamic value) : value = value.toString();
}

enum PlayMode {
  NORMAL,
  REPEAT_ALL,
  INTRO,
}

enum TransportState {
  STOPPED,
  PAUSED_PLAYBACK,
  PAUSED_RECORDING,
  PLAYING,
  RECORDING,
  TRANSITIONING,
  NO_MEDIA_PRESENT,
}
