// ignore_for_file: constant_identifier_names, avoid_print

import 'dart:async';

import 'package:my_dart_cast_demo/src/dlna_service.dart';
import 'package:my_dart_cast_demo/src/http/http_client.dart';
import 'package:my_dart_cast_demo/src/parser.dart';
import 'package:my_dart_cast_demo/src/ssdp/ssdp_message_parser.dart';
import 'package:my_dart_cast_demo/src/ssdp/ssdp_service.dart';

import '../dlna_device.dart';

typedef OnDeviceAdd = void Function(DLNADevice device);
typedef OnDeviceUpdate = void Function(DLNADevice device);
typedef OnDeviceRemove = void Function(DLNADevice device);

class DiscoveryDeviceManager {
  DiscoveryDeviceManager();

  final SSDPService _ssdpService = SSDPService();
  final SSDPMessageParser _parser = SSDPMessageParser();
  final Map<String, DLNADevice> _currentDevices = {};
  final List<String> _descriptionTask = [];

  void Function(DLNADevice device)? _onDeviceAdd;
  void Function(DLNADevice device)? _onDeviceUpdate;
  void Function(DLNADevice device)? _onDeviceRemove;

  void listen({
    OnDeviceAdd? onDeviceAdd,
    OnDeviceUpdate? onDeviceUpdate,
    OnDeviceRemove? onDeviceRemove,
  }) {
    _onDeviceAdd = onDeviceAdd;
    _onDeviceUpdate = onDeviceUpdate;
    _onDeviceRemove = onDeviceRemove;
  }

  void search() async {
    if (!_ssdpService.isRunning) {
      await _ssdpService.start();
      _ssdpService.listen(_onData);
    }
    _ssdpService.search();
  }

  void _onData(data) async {
    final device = _parser.parse(data);
    if (device != null) {
      if (device.alive) {
        if (!_currentDevices.containsKey(device.usn)) {
          if (!_descriptionTask.contains(device.location)) {
            _descriptionTask.add(device.location);
            device.detail = await getDeviceDescription(device);
            _descriptionTask.remove(device.location);
            _currentDevices[device.usn] = device;
            _onDeviceAdd?.call(device);
          }
        } else {}
      } else {
        final removedDevice = _currentDevices.remove(device.usn);
        if (removedDevice != null) {
          _onDeviceRemove?.call(removedDevice);
        }
        _descriptionTask.remove(device.location);
      }
    }
  }

  Future<DLNADeviceDetail> getDeviceDescription(DLNADevice device) async {
    final response = await MyHttpClient().getUrl(device.location);
    final jsonObj = parseXml2Json(response);
    final detail = DLNADeviceDetail.fromJson(jsonObj['root']['device']);
    detail.baseUrl = DlnaParser.parseBaseUrl(device.location);
    var endTime = DateTime.now().millisecondsSinceEpoch;
    device.lastDescriptionTime = endTime;

    final futures = detail.serviceList.map((e) => _getServiceAction(e));
    await Future.wait(futures);
    return detail;
  }

  Future<void> _getServiceAction(DLNAService service) async {
    final url = service.baseUrl + service.scpdUrl;
    final response = await MyHttpClient().getUrl(url);
    service.actionList = DlnaParser.parseServiceAction(response, xml: true);
  }
}
