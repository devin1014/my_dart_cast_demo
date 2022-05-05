import 'dart:collection';

import 'package:my_dart_cast_demo/src/dlna.dart';
import 'package:my_dart_cast_demo/src/virtual_device/virtual_device.dart';
import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart';

/// --------------------------------------------------------
/// ---- Builder
/// --------------------------------------------------------
class VirtualDeviceBuilder {
  final String udn;

  final String _deviceType;

  final List<String> _serviceTypes;

  final LinkedHashMap<String, String> _categoryMap = LinkedHashMap();

  String get deviceType => _deviceType;

  String get description => _buildDescription();

  String get location => "/description.xml";

  List<String> get services => _serviceTypes.map((e) => DLNAProtocol.getServiceType(e)).toList();

  VirtualDeviceBuilder({
    required String deviceType,
    required String deviceName,
    required List<String> serviceTypes,
    String presentationURL = "https://github.com/devin1014/my_dart_cast_demo",
    String manufacturer = "dart",
    String manufacturerURL = "",
    String modelName = "",
    String modelURL = "",
    String modelDescription = "virtual device",
    Map<String, String>? category,
  })  : _deviceType = DLNAProtocol.getDeviceType(deviceType),
        _serviceTypes = serviceTypes,
        udn = _buildUUID([deviceType, deviceName, presentationURL, serviceTypes.toString()]) {
    if (category != null) {
      _categoryMap.addAll(category);
    }
    _categoryMap["friendlyName"] = deviceName;
    _categoryMap["presentationURL"] = presentationURL;
    _categoryMap["manufacturer"] = manufacturer;
    _categoryMap["manufacturerURL"] = manufacturerURL;
    _categoryMap["modelName"] = modelName;
    _categoryMap["modelURL"] = modelURL;
    _categoryMap["modelDescription"] = modelDescription;
  }

  static String _buildUUID(List<String> list) {
    final name = "dart:lw:${list.join(";")}";
    return "uuid:${const Uuid().v5(Uuid.NAMESPACE_DNS, name)}";
  }

  String _buildDescription() {
    final builder = XmlBuilder();
    builder.declaration(version: "1.0");
    builder.element(
      "root",
      attributes: {"xmlns": "urn:schemas-upnp-org:device-1-0"},
      nest: () {
        builder.element("specVersion", nest: () {
          builder.element("major", nest: 1);
          builder.element("minor", nest: 0);
        });
        builder.element("device", nest: () {
          builder.element("deviceType", nest: _deviceType);
          builder.element("UDN", nest: udn);
          builder.element("UID", nest: udn.hashCode);
          _categoryMap.forEach((key, value) {
            builder.element(key, nest: value);
          });
          builder.element("serviceList", nest: () {
            for (var type in _serviceTypes) {
              _buildService(builder, type);
            }
          });
        });
      },
    );
    return builder.buildDocument().toXmlString(pretty: true);
  }

  void _buildService(XmlBuilder builder, String serviceType) {
    builder.element("service", nest: () {
      builder.element("serviceType", nest: DLNAProtocol.getServiceType(serviceType));
      builder.element("serviceId", nest: DLNAProtocol.getServiceId(serviceType));
      builder.element("SCPDURL", nest: "/dlna/$serviceType/scpd");
      builder.element("controlURL", nest: "/dlna/$serviceType/control");
      builder.element("eventSubURL", nest: "/dlna/$serviceType/event");
    });
  }

  VirtualDevice build() => VirtualDevice(this);
}
