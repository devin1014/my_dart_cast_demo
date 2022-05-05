// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:my_dart_cast_demo/src/http/http_server.dart';
import 'package:my_dart_cast_demo/src/ssdp/ssdp_service.dart';
import 'package:my_dart_cast_demo/src/ssdp/upnp_message.dart';
import 'package:my_dart_cast_demo/src/util.dart';
import 'package:my_dart_cast_demo/src/virtual_device/virtual_device_builder.dart';

class VirtualDevice {
  final String usn;
  final String deviceType;
  final List<String> serviceType;
  final String _description;
  final LocalHttpServer _localHttpServer = LocalHttpServer();
  final SSDPService _ssdpService = SSDPService();
  String _location = "";

  VirtualDevice(VirtualDeviceBuilder builder)
      : usn = builder.udn,
        deviceType = builder.deviceType,
        serviceType = builder.services,
        _description = builder.description;

  Timer? _timer;

  Future<void> start() async {
    if (_localHttpServer.isRunning) return;
    try {
      await _ssdpService.start();
      _ssdpService.listen((data) {
        printlnLog("ssdpService", data);
      });

      await _localHttpServer.start((request) {
        final uri = request.uri;
        final response = request.response;
        if (uri.path == "/description.xml") {
          response.contentLength = utf8.encode(_description).length;
          response.write(_description);
        }
        response.close();
      });

      _location = "${_localHttpServer.getBaseUrl()}/description.xml";

      final messageList = UpnpMessage.buildNotifyList(
        usn: usn,
        location: _location,
        ntList: _buildDeviceServices(),
      );
      for (var element in messageList) {
        _ssdpService.sendMessage(element);
      }
      _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
        for (var element in messageList) {
          _ssdpService.sendMessage(element);
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> stop() async {
    try {
      final messageList = UpnpMessage.buildNotifyList(
        usn: usn,
        location: _location,
        ntList: _buildDeviceServices(),
      );
      for (var element in messageList) {
        _ssdpService.sendMessage(element);
      }
      _ssdpService.stop();
      _timer?.cancel();
      await _localHttpServer.stop();
    } catch (e) {
      print(e.toString());
    }
  }

  List<String> _buildDeviceServices() {
    final List<String> list = ["upnp:rootdevice", deviceType];
    list.addAll(serviceType);
    return list;
  }

  @override
  String toString() {
    return "usn:$usn, location:$_location, deviceType:$deviceType, serviceType:${serviceType.toList()}";
  }
}
