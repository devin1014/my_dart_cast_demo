// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:my_dart_cast_demo/src/dlna_device.dart';
import 'package:xml2json/xml2json.dart';

class DlnaParser {
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

  DlnaParser._();

  static DLNADeviceDetail parseDeviceDetail(dynamic data, {bool xml = false}) {
    final jsonObj = _formatData2Json(data, xml: xml);
    final detail = DLNADeviceDetail.fromJson(jsonObj['root']['device']);
    detail.baseURL = jsonObj['root']["URLBase"] ?? detail.baseURL;
    return detail;
  }

  static List<DLNAServiceAction>? parseServiceAction(dynamic data, {bool xml = false}) {
    dynamic jsonObj = _formatData2Json(data, xml: xml);
    if (jsonObj['scpd']["actionList"] == null) return null;
    final List<dynamic> list;
    final result = jsonObj["scpd"]["actionList"]["action"];
    if (result is List) {
      list = result;
    } else {
      list = [result];
    }
    return list.map((e) => DLNAServiceAction.fromJson(e as Map<String, dynamic>)).toList(growable: false);
  }

  static Map _formatData2Json(dynamic data, {bool xml = false}) {
    if (data is Map) {
      return data;
    } else if (data is String) {
      if (xml) {
        return parseXml2Json(data);
      } else {
        return jsonDecode(data);
      }
    }
    throw Exception("can not parse $data to Map.");
  }

  static String parseBaseUrl(String url) => "http://${Uri.parse(url).authority}";
}

final Xml2Json _xml2json = Xml2Json();

dynamic parseXml2Json(String xml) {
  final xml2Json = _xml2json;
  xml2Json.parse(xml);
  return jsonDecode(xml2Json.toParker());
}
