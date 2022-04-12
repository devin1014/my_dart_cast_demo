// ignore_for_file: avoid_print

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
