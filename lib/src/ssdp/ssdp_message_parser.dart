// ignore_for_file: constant_identifier_names

import 'package:my_dart_cast_demo/src/dlna_device.dart';

class SSDPMessageParser {
  static const _SSDP_MSG_ALIVE = 'ssdp:alive';
  static const _SSDP_MSG_BYE_BYE = 'ssdp:byebye';
  static const _HEADER_USN = "USN";
  static const _HEADER_LOCATION = "LOCATION";
  static const _HEADER_CACHE_CONTROL = "CACHE-CONTROL";
  static const _HEADER_NTS = "NTS";
  static const _HEADER_HTTP_VER_1 = "HTTP/1.";
  static const _HEADER_NOTIFY = "NOTIFY";
  static const _HEADER_M_SEARCH = "M-SEARCH";
  static const _HEADER_OK = "OK";

  // void Function(String usn, String location, String cache) processAlive;
  // void Function(String usn) processByeBye;

  SSDPMessageParser();

  DLNADevice? parse(String message) {
    var lines = message.split('\r\n');
    if (lines.length < 3) return null;
    final firstLine = lines.first.split(' ');
    var action = firstLine.first;
    if (action.startsWith(_HEADER_HTTP_VER_1) && firstLine[2] == _HEADER_OK) {
      return _parseSearchMessage(lines);
    } else if (action == _HEADER_NOTIFY) {
      return _parseNotifyMessage(lines);
    } else {
      return null;
    }
  }

  DLNADevice? _parseSearchMessage(List<String> lines) {
    final headers = _parseHeader(lines);
    final usn = headers[_HEADER_USN];
    if (usn?.isNotEmpty == true && usn!.contains("::")) {
      final location = headers[_HEADER_LOCATION] ?? "";
      final cacheControl = headers[_HEADER_CACHE_CONTROL] ?? "";
      int cacheTime = int.parse(cacheControl.substring(8));
      return DLNADevice(usn: usn, location: location, cacheControl: cacheTime);
    }
    return null;
  }

  DLNADevice? _parseNotifyMessage(List<String> lines) {
    final headers = _parseHeader(lines);
    final usn = headers[_HEADER_USN];
    if (usn?.isNotEmpty == true && usn!.contains("::")) {
      final location = headers[_HEADER_LOCATION] ?? "";
      final cacheControl = headers[_HEADER_CACHE_CONTROL] ?? "";
      int cacheTime = int.parse(cacheControl.substring(8));
      final device = DLNADevice(usn: usn, location: location, cacheControl: cacheTime);
      if (headers[_HEADER_NTS] == _SSDP_MSG_ALIVE) {
        device.alive = true;
      } else if (headers[_HEADER_NTS] == _SSDP_MSG_BYE_BYE) {
        device.alive = false;
      }
      return device;
    }
    return null;
  }

  Map<String, String> _parseHeader(List<String> lines) {
    Map<String, String> result = {};
    for (var element in lines) {
      if (element.isNotEmpty) {
        var headers = element.split(': ');
        if (headers.length >= 2) {
          result[headers.first.toUpperCase()] = headers[1];
        }
      }
    }
    return result;
  }
}
