// ignore_for_file: constant_identifier_names, avoid_print

void printLog(String tag, dynamic object, {bool timeStamp = true}) {
  print("${getTimeNow()} [$tag]: $object");
}

void printlnLog(String tag, dynamic object, {bool timeStamp = true}) {
  print("${getTimeNow()} [$tag]: \n$object");
}

String getTimeNow() {
  final time = DateTime.now();
  return "${time.year}-${time.month}-${time.day} "
      "${formatTime(time.hour)}:${formatTime(time.minute)}:${formatTime(time.second)}";
}

String formatTime(int num) => (num < 10) ? "0$num" : "$num";
