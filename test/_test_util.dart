// ignore_for_file: avoid_print

import 'dart:io';

void printWithTime(String? msg) {
  final dateTime = DateTime.now();
  print("${dateTime.hour}:${dateTime.minute}:${dateTime.second} -> $msg");
}

String getTimeStamp() {
  final dateTime = DateTime.now();
  return "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
}

class TimeStamp {
  TimeStamp();

  int _timeStamp = _getTime();
  int _tag = 1;
  final Map<int, int> _timeTags = {};

  int tag() {
    _timeTags[_tag] = _getTime();
    return _tag++;
  }

  int get() {
    final oldTimeStamp = _timeStamp;
    _timeStamp = _getTime();
    return _timeStamp - oldTimeStamp;
  }

  int getTag(int tag) {
    final time = _timeTags[tag];
    if (time == null) return -1;
    return _getTime() - time;
  }

  static int _getTime() => DateTime.now().millisecondsSinceEpoch;
}

/// -------------------------------------------------------------
/// print NetworkInterface information
/// -------------------------------------------------------------
Future printNetworkInterfaces() async {
  print("---- NetworkInterface list ----------------------------------------");

  var list = await NetworkInterface.list(type: InternetAddress.anyIPv4.type);
  list.map((e) => "'${e.name}': ${e.addresses.toString()}").forEach(_print);

  print("\n");
  print("[includeLinkLocal, includeLoopback]");
  list = await NetworkInterface.list(type: InternetAddress.anyIPv4.type, includeLinkLocal: true, includeLoopback: true);
  list.map((e) => "'${e.name}': ${e.addresses.toString()}").forEach(_print);

  print("\n");
  print("[anyIPv4, loopbackIPv4]");
  print("${InternetAddress.anyIPv4}");
  print("${InternetAddress.loopbackIPv4}");
  print("--------------------------------------------------------------------");
}

void _print(dynamic obj) => print(obj);

void printLog(String tag, dynamic object, {bool timeStamp = true}) {
  print("${getTimeNow()} [$tag]: $object");
}

String getTimeNow() {
  final time = DateTime.now();
  return "${time.year}-${time.month}-${time.day} "
      "${formatTime(time.hour)}:${formatTime(time.minute)}:${formatTime(time.second)}";
}

String formatTime(int num) => (num < 10) ? "0$num" : "$num";
