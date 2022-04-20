import 'package:my_dart_cast_demo/src/dlna_service.dart';
import 'package:my_dart_cast_demo/src/http/http_client.dart';

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
    return parseResult(response);
  }

  Map<String, String>? getHeader() => null;

  String? getContent() => null;

  dynamic parseResult(String response) => response;

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
    final name = getSoapActionArgument().first.name;
    final value = getSoapActionArgument().first.value;
    return "<$name>$value</$name>";
  }

  List<ServiceActionArgument> getSoapActionArgument() => [ServiceActionArgument("InstanceID", 0)];
}

class ServiceActionArgument {
  final String name;
  final String value;

  ServiceActionArgument(this.name, dynamic value) : value = value.toString();
}
