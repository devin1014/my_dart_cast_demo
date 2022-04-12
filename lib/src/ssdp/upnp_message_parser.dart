// ignore_for_file: constant_identifier_names

class DiscoveryContentParser {
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

  void Function(String usn, String location, String cache) processAlive;
  void Function(String usn) processByeBye;

  DiscoveryContentParser({
    required this.processAlive,
    required this.processByeBye,
  });

  void startParse(String message) {
    var messageLines = message.split('\r\n');
    if (messageLines.length < 3) {
      return;
    }
    var firstLine = messageLines.first;
    var firstLineParameter = firstLine.split(' ').first;
    if (firstLineParameter.startsWith(_HEADER_HTTP_VER_1)) {
      var httpProtocol = firstLine[2];
      if (httpProtocol == _HEADER_OK) {
        readSearchResponseMessage(messageLines);
      }
    } else {
      if (firstLineParameter == _HEADER_NOTIFY) {
        readNotifyMessage(messageLines);
      } else if (firstLineParameter != _HEADER_M_SEARCH) {}
    }
  }

  void readSearchResponseMessage(List<String> lines) {
    final headers = parseHeader(lines);
    final usn = headers[_HEADER_USN];
    if (usn?.isNotEmpty == true) {
      final location = headers[_HEADER_LOCATION];
      final cacheControl = headers[_HEADER_CACHE_CONTROL];
      if (location?.isNotEmpty == true && cacheControl?.isNotEmpty == true) {
        processAlive(usn!, location!, cacheControl!);
      }
    }
  }

  void readNotifyMessage(List<String> lines) {
    final headers = parseHeader(lines);
    final usn = headers[_HEADER_USN];
    if (usn?.isNotEmpty == true) {
      if (headers[_HEADER_NTS] == _SSDP_MSG_ALIVE) {
        final location = headers[_HEADER_LOCATION];
        final cacheControl = headers[_HEADER_CACHE_CONTROL];
        if (location?.isNotEmpty == true && cacheControl?.isNotEmpty == true) {
          processAlive(usn!, location!, cacheControl!);
        }
      } else if (headers[_HEADER_NTS] == _SSDP_MSG_BYE_BYE) {
        processByeBye(usn!);
      }
    }
  }

  Map<String, String> parseHeader(List<String> lines) {
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
