// ignore_for_file: constant_identifier_names, avoid_print

import 'dart:async';

import 'package:my_dart_cast_demo/src/http/http_client.dart';
import 'package:my_dart_cast_demo/src/parser.dart';
import 'package:my_dart_cast_demo/src/ssdp/ssdp_message_parser.dart';
import 'package:my_dart_cast_demo/src/ssdp/ssdp_service.dart';

import '../dlna_device.dart';

typedef OnDeviceAdd = void Function(DLNADevice device);
typedef OnDeviceUpdate = void Function(DLNADevice device);
typedef OnDeviceRemove = void Function(DLNADevice device);

// class DiscoveryDeviceManager {
//   static const int FROM_ADD = 1;
//   static const int FROM_UPDATE = 2;
//   static const int FROM_CACHE_ADD = 3;
//
//   // 150s = 2.5min
//   static const int DEVICE_DESCRIPTION_INTERVAL_TIME = 150000;
//
//   // 5min
//   static const DEVICE_ALIVE_CHECK_INTERVAL_TIME = Duration(minutes: 5);
//   static const DEVICE_ALIVE_CHECK_RETRY_INTERVAL_TIME = Duration(seconds: 30);
//
//   final int _startSearchTime = DateTime.now().millisecondsSinceEpoch;
//   final List<String> _descTasks = [];
//   final Map<String, int> _unnecessaryDevices = {};
//   final Map<String, DLNADevice> _currentDevices = {};
//
//   // final DescriptionParser _descriptionParser = DescriptionParser();
//   // final LocalDeviceParser _localDeviceParser = LocalDeviceParser();
//
//   Timer? _timer;
//
//   // bool _enableCache = false;
//   bool _disable = false;
//
//   final OnDeviceAdd _onDeviceAdd;
//   final OnDeviceUpdate _onDeviceUpdate;
//   final OnDeviceRemove _onDeviceRemove;
//
//   DiscoveryDeviceManager({
//     required OnDeviceAdd onDeviceAdd,
//     required onDeviceUpdate,
//     required onDeviceRemove,
//   })  : _onDeviceAdd = onDeviceAdd,
//         _onDeviceUpdate = onDeviceAdd,
//         _onDeviceRemove = onDeviceRemove;
//
//   // void enableCache() {
//   //   _enableCache = true;
//   // }
//   //
//   // Future<List<DLNADevice>> getLocalDevices() async {
//   //   return _localDeviceParser.findAndConvert();
//   // }
//   //
//
//   void enable() {
//     _disable = false;
//     _timer = Timer.periodic(DEVICE_ALIVE_CHECK_INTERVAL_TIME, (Timer t) {
//       if (_disable) {
//         return;
//       }
//       _currentDevices.forEach((key, value) {
//         _checkAliveDevice(value, 0);
//       });
//     });
//     // if (_enableCache) {
//     //   getLocalDevices().then((devices) {
//     //     if (devices != null) {
//     //       for (var device in devices) {
//     //         _cacheAlive(device);
//     //       }
//     //     }
//     //   }).catchError((error) {});
//     // }
//   }
//
//   void disable() {
//     _timer?.cancel();
//     _disable = true;
//   }
//
//   void release() {
//     disable();
//     _descTasks.clear();
//     _currentDevices.clear();
//     _unnecessaryDevices.clear();
//   }
//
//   Future<void> alive(String usn, String location, String cache) async {
//     if (_disable) return;
//     final split = usn.split('::').where((element) => element.isNotEmpty);
//     if (split.isEmpty) return;
//     final uuid = split.first;
//     int cacheTime;
//     try {
//       /// max-age=66
//       cacheTime = int.parse(cache.substring(8));
//     } catch (ignore) {
//       cacheTime = 3600;
//     }
//     DLNADevice? tmpDevice = _currentDevices[uuid];
//     if (tmpDevice == null) {
//       int count = _unnecessaryDevices[location] ??= 0;
//       if (count > 3) return;
//       final hasTask = _descTasks.contains(uuid);
//       if (hasTask) return;
//       final device = DLNADevice(usn: usn, location: location);
//       device.cacheTime = cacheTime;
//       _descTasks.add(device.usn);
//       await _getDetail(device, count, FROM_ADD);
//     } else {
//       var hasTask = _descTasks.contains(uuid);
//       if (hasTask) return;
//       var isLocationChang = (location != tmpDevice.location);
//       var diff = DateTime.now().millisecondsSinceEpoch - tmpDevice.lastDescriptionTime;
//       if (diff > DEVICE_DESCRIPTION_INTERVAL_TIME || isLocationChang) {
//         tmpDevice.location = location;
//         _descTasks.add(uuid);
//         await _getDetail(tmpDevice, 0, FROM_UPDATE);
//       }
//     }
//   }
//
//   void byeBye(String usn) {
//     if (_disable) return;
//     var split = usn.split('::').where((element) => element.isNotEmpty);
//     if (split.isEmpty) return;
//     _onRemove(split.first);
//   }
//
//   void _cacheAlive(DLNADevice device) async {
//     if (_disable) {
//       return;
//     }
//     var hasTask = _descTasks.contains(device.usn);
//     if (hasTask) {
//       return;
//     }
//     _descTasks.add(device.usn);
//     await _getDetail(device, 0, FROM_CACHE_ADD);
//   }
//
//   void _checkAliveDevice(DLNADevice device, int count) {
//     // _descriptionParser.getDescription(device).then((value) {
//     //   if (value == null) {
//     //     if (count >= 3) {
//     //       _onRemove(device.usn);
//     //     } else {
//     //       Future.delayed(DEVICE_ALIVE_CHECK_RETRY_INTERVAL_TIME, () {
//     //         _checkAliveDevice(device, count + 1);
//     //       });
//     //     }
//     //   }
//     // }).catchError((e) {
//     //   if (count >= 3) {
//     //     _onRemove(device.usn);
//     //   } else {
//     //     Future.delayed(DEVICE_ALIVE_CHECK_RETRY_INTERVAL_TIME, () {
//     //       _checkAliveDevice(device, count + 1);
//     //     });
//     //   }
//     // });
//   }
//
//   Future<void> _getDetail(DLNADevice device, int tryCount, int type) async {
//     try {
//       final startTime = DateTime.now().millisecondsSinceEpoch;
//       final response = await MyHttpClient().getUrl(device.location);
//       final jsonObj = parseXml2Json(response);
//       final detail = DLNADeviceDetail.fromJson(jsonObj['root']['device']);
//       detail.baseURL = jsonObj['root']["URLBase"];
//       device.detail = detail;
//       var endTime = DateTime.now().millisecondsSinceEpoch;
//       device.lastDescriptionTime = endTime;
//
//       final baseUrl = detail.baseURL;
//       final futures = detail.serviceList.map((e) => _getServiceAction(baseUrl, e));
//       await Future.wait(futures);
//
//       if (detail.avTransportControlURL.isEmpty) {
//         tryCount++;
//         _onUnnecessary(device, tryCount);
//         return;
//       }
//       switch (type) {
//         case FROM_ADD:
//           {
//             _onAdd(device);
//           }
//           break;
//         case FROM_UPDATE:
//           {
//             _onUpdate(device);
//           }
//           break;
//         case FROM_CACHE_ADD:
//           {
//             _onCacheAdd(device);
//           }
//           break;
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//
//   Future<void> _getServiceAction(String baseUrl, DLNAService service) async {
//     final url = baseUrl + service.scpdUrl;
//     final response = await MyHttpClient().getUrl(url);
//     service.actionList = DlnaParser.parseServiceAction(response, xml: true);
//   }
//
//   void _onUnnecessary(DLNADevice device, int count) {
//     _unnecessaryDevices[device.location] = count;
//     _descTasks.remove(device.usn);
//   }
//
//   void _onAdd(DLNADevice device) {
//     device.discoveryFromStartSpendingTime = DateTime.now().millisecondsSinceEpoch - _startSearchTime;
//     // device.isFromCache = false;
//     _currentDevices[device.usn] = device;
//     // if (_enableCache) {
//     // _localDeviceParser.saveDevices(_currentDevices);
//     // }
//     _descTasks.remove(device.usn);
//     _onDeviceAdd(device);
//   }
//
//   void _onCacheAdd(DLNADevice device) {
//     device.discoveryFromStartSpendingTime = DateTime.now().millisecondsSinceEpoch - _startSearchTime;
//     // device.isFromCache = true;
//     _currentDevices[device.usn] = device;
//     // if (_enableCache) {
//     // _localDeviceParser.saveDevices(_currentDevices);
//     // }
//     _descTasks.remove(device.usn);
//     _onDeviceAdd(device);
//   }
//
//   void _onUpdate(DLNADevice device) {
//     _currentDevices[device.usn] = device;
//     // if (_enableCache) {
//     // _localDeviceParser.saveDevices(_currentDevices);
//     // }
//     _descTasks.remove(device.usn);
//     _onDeviceUpdate(device);
//   }
//
//   void _onRemove(String uuid) {
//     DLNADevice? device = _currentDevices.remove(uuid);
//     if (device != null) {
//       // if (_enableCache) {
//       // _localDeviceParser.saveDevices(_currentDevices);
//       // }
//       _onDeviceRemove(device);
//     }
//   }
// }

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
            device.detail = await _getDeviceDescription(device);
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

  Future<DLNADeviceDetail> _getDeviceDescription(DLNADevice device) async {
    final response = await MyHttpClient().getUrl(device.location);
    final jsonObj = parseXml2Json(response);
    final detail = DLNADeviceDetail.fromJson(jsonObj['root']['device']);
    detail.baseURL = jsonObj['root']["URLBase"] ?? DlnaParser.parseBaseUrl(device.location);
    //device.detail = detail;
    var endTime = DateTime.now().millisecondsSinceEpoch;
    device.lastDescriptionTime = endTime;

    final baseUrl = detail.baseURL;
    final futures = detail.serviceList.map((e) => _getServiceAction(baseUrl, e));
    await Future.wait(futures);
    return detail;
  }

  Future<void> _getServiceAction(String baseUrl, DLNAService service) async {
    final url = baseUrl + service.scpdUrl;
    final response = await MyHttpClient().getUrl(url);
    service.actionList = DlnaParser.parseServiceAction(response, xml: true);
  }
}
