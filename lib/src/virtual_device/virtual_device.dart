// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:async';

import 'package:my_dart_cast_demo/src/http/http_server.dart';
import 'package:my_dart_cast_demo/src/ssdp/ssdp_service.dart';
import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart';

class VirtualDevice {
  final VirtualDeviceBuilder _builder;
  final MyLocalHttpServer _localHttpServer = MyLocalHttpServer();
  final SSDPService _ssdpService = SSDPService();

  VirtualDevice._(VirtualDeviceBuilder builder) : _builder = builder;

  Future<void> start() async {
    if (_localHttpServer.isRunning) return;
    try {
      await _ssdpService.start();
      Timer.periodic(const Duration(seconds: 10), (timer) {
        _ssdpService.notify(_builder._udn, _builder.location, true);
      });
      await _localHttpServer.start();
      _localHttpServer.bindDeviceBuilder(_builder);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> stop() async {
    try {
      _ssdpService.notify(_builder._udn, _builder.location, false);
      _ssdpService.stop();
      await _localHttpServer.stop();
    } catch (e) {
      print(e.toString());
    }
  }
}

class VirtualDeviceBuilder {
  static const _rendererServices = ["AVTransport", "ConnectionManager", "RenderingControl"];

  final String deviceType;

  final String presentationURL;

  final String friendlyName;

  final String manufacturer;

  final String manufacturerURL;

  final String modelDescription;

  final String modelName;

  final String modelURL;

  final String UPC;

  String _host = "";

  set host(String value) {
    _host = value;
  }

  int _port = 0;

  set port(int value) {
    _port = value;
  }

  String _udn = "";

  final List<String> _serviceTypes = [];

  VirtualDeviceBuilder({
    required this.deviceType,
    List<String> services = _rendererServices,
    this.presentationURL = "https://github.com/devin1014/my_dart_cast_demo",
    required this.friendlyName,
    this.manufacturer = "dart",
    this.manufacturerURL = "",
    this.modelName = "dlna renderer",
    this.modelURL = "https://github.com/devin1014/my_dart_cast_demo",
    this.modelDescription = "",
    this.UPC = "",
  }) {
    _udn = _buildUUID();
    if (services.isNotEmpty == true) {
      _serviceTypes.addAll(services);
    }
  }

  String get URLBase => _host.isNotEmpty ? "http://$_host:$_port" : "";

  String get description => _buildDescription();

  String get location => "$URLBase/description.xml";

  String _buildUUID() {
    final name = "$deviceType$presentationURL$friendlyName";
    return "uuid:${const Uuid().v5(Uuid.NAMESPACE_DNS, "uuid:by:lw:$name")}";
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
          builder.element("deviceType", nest: deviceType);
          builder.element("presentationURL", nest: presentationURL);
          builder.element("friendlyName", nest: friendlyName);
          builder.element("manufacturer", nest: manufacturer);
          builder.element("manufacturerURL", nest: manufacturerURL);
          builder.element("modelName", nest: modelName);
          builder.element("modelURL", nest: modelURL);
          builder.element("modelDescription", nest: modelDescription);
          builder.element("UPC", nest: UPC);
          builder.element("UDN", nest: _udn);
          builder.element("UID", nest: _udn.hashCode);
          builder.element("serviceList", nest: () {
            for (var type in _serviceTypes) {
              _buildService(builder, type);
            }
          });
        });
        builder.element("URLBase", nest: URLBase);
      },
    );
    return builder.buildDocument().toXmlString(pretty: true);
  }

  void _buildService(XmlBuilder builder, String serviceType) {
    builder.element("service", nest: () {
      builder.element("serviceType", nest: "urn:schemas-upnp-org:service:$serviceType:1");
      builder.element("serviceId", nest: "urn:schemas-upnp-org:serviceId:$serviceType");
      builder.element("SCPDURL", nest: "/dlna/Render/${serviceType}_scpd.xml");
      builder.element("controlURL", nest: "_urn:schemas-upnp-org:service:${serviceType}_control");
      builder.element("eventSubURL", nest: "_urn:schemas-upnp-org:service:${serviceType}_event");
    });
  }

  VirtualDevice build() => VirtualDevice._(this);
}
