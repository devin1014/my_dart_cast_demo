import 'package:my_dart_cast_demo/src/soap/action_result.dart';
import 'package:my_dart_cast_demo/src/soap/service_actions.dart';
import 'package:my_dart_cast_demo/src/dlna_service.dart';

class GetProtocolInfo extends AbstractServiceAction {
  GetProtocolInfo(DLNAService service) : super(service);

  @override
  parseResult(Map<String, dynamic> response) {
    final json=response["s:Envelope"]["s:Body"]["u:GetProtocolInfoResponse"];
    return GetProtocolInfoResponse.fromJson(json);
  }
}
