// ignore_for_file: constant_identifier_names

import 'package:my_dart_cast_demo/src/dlna_service.dart';
import 'package:my_dart_cast_demo/src/http/http_client.dart';
import 'package:my_dart_cast_demo/src/parser.dart';
import 'package:my_dart_cast_demo/src/soap/action_result.dart';
import 'package:xml/xml.dart';

abstract class AbstractServiceAction {
  static const _objectAttribute = {
    "s:encodingStyle": "http://schemas.xmlsoap.org/soap/encoding/",
    "xmlns:s": "http://schemas.xmlsoap.org/soap/envelope/"
  };

  AbstractServiceAction(this.service);

  final DLNAService service;

  Future<dynamic> execute() async {
    final url = service.baseUrl + "/" + service.controlUrl;
    final response = await MyHttpClient().postUrl(
      url: url,
      header: getHeader() ?? {"SoapAction": _parseAction(service)},
      content: getContent() ?? parseXmlData2(service),
    );
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

  String parseXmlData2(DLNAService service) {
    final builder = XmlBuilder();
    builder.declaration(
      version: "1.0",
      encoding: "utf-8",
      attributes: {"standalone": "yes"},
    );
    builder.element(
      "s:Envelope",
      attributes: _objectAttribute,
      nest: () {
        builder.element(
          "s:Body",
          nest: () {
            builder.element(
              "u:${getSoapAction()}",
              attributes: {"xmlns:u": service.type},
              nest: () {
                getSoapActionArgument().forEach((element) {
                  if (!element.isXmlData) {
                    builder.element(element.name, nest: element.value);
                  } else {
                    builder.xml("<${element.name}>${element.value}</${element.name}>");
                  }
                });
              },
            );
          },
        );
      },
    );
    return builder.buildDocument().toXmlString(pretty: false);
  }

  static final List<ServiceActionArgument> _instanceIdArgument = [ServiceActionArgument("InstanceID", 0)];

  List<ServiceActionArgument> getSoapActionArgument() => _instanceIdArgument;
}

class ServiceActionArgument {
  final String name;
  final String value;
  final bool isXmlData;

  ServiceActionArgument(this.name, dynamic value, {this.isXmlData = false}) : value = value.toString();
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
