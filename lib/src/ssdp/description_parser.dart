import 'dart:convert';

import 'package:xml2json/xml2json.dart';

import '../dlna_device.dart';

class DescriptionParser {
  static const String DEVICE_TYPE = "deviceType";
  static const String UDN = "UDN";
  static const String FRIEND_NAME = "friendlyName";
  static const String MANUFACTURER = "manufacturer";
  static const String MANUFACTURER_URL = "manufacturerURL";
  static const String MODEL_DESCRIPTION = "modelDescription";
  static const String MODEL_NAME = "modelName";
  static const String MODEL_URL = "modelURL";
  static const String SERVICE = "service";
  static const String SERVICE_TYPE = "serviceType";
  static const String SERVICE_ID = "serviceId";
  static const String CONTROL_URL = "controlURL";
  static const String EVENT_SUB_URL = "eventSubURL";
  static const String SCPDURL = "SCPDURL";

  static const String X_RCONTROLLER_DEVICEINFO = "x_rcontroller_deviceinfo";
  static const String X_RCONTROLLER_VERSION = "x_rcontroller_version";
  static const String X_RCONTROLLER_SERVICE = "x_rcontroller_service";
  static const String X_RCONTROLLER_SERVICETYPE = "x_rcontroller_servicetype";
  static const String X_RCONTROLLER_ACTIONLIST_URL = "x_rcontroller_actionlist_url";

  static const String AV_X_RCONTROLLER_DEVICEINFO = "av:x_rcontroller_deviceinfo";
  static const String AV_X_RCONTROLLER_VERSION = "av:x_rcontroller_version";
  static const String AV_X_RCONTROLLER_SERVICE = "av:x_rcontroller_service";
  static const String AV_X_RCONTROLLER_SERVICETYPE = "av:x_rcontroller_servicetype";
  static const String AV_X_RCONTROLLER_ACTIONLIST_URL = "av:x_rcontroller_actionlist_url";

  static const String AV_TRANSPORT = "urn:schemas-upnp-org:service:AVTransport:1";
  static const String RENDERING_CONTROL = "urn:schemas-upnp-org:service:RenderingControl:1";
  static const String CONNECTION_MANAGER = "urn:schemas-upnp-org:service:ConnectionManager:1";

  Future<DLNADescription> getDescription(String data) async {
    final xml2Json = Xml2Json();
    xml2Json.parse(data);
    String jsonStr = xml2Json.toParker();
    final jsonObj = jsonDecode(jsonStr);

    final root = jsonObj['root'];
    final device = root['device'];
    return DLNADescription.fromJson(device);
  }
}
