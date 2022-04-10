class DiscoveryContentParser {
  static const SSDP_MSG_ALIVE = 'ssdp:alive';
  static const SSDP_MSG_BYE_BYE = 'ssdp:byebye';

  final HEADER_USN = "USN";
  final HEADER_LOCATION = "LOCATION";
  final HEADER_CACHE_CONTROL = "CACHE-CONTROL";
  final HEADER_NTS = "NTS";
  final HEADER_HTTP_VER_1 = "HTTP/1.";
  final HEADER_NOTIFY = "NOTIFY";
  final HEADER_M_SEARCH = "M-SEARCH";
  final HEADER_OK = "OK";

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
    if (firstLineParameter.startsWith(HEADER_HTTP_VER_1)) {
      var httpProtocol = firstLine[2];
      if (httpProtocol == HEADER_OK) {
        readSearchResponseMessage(messageLines);
      }
    } else {
      if (firstLineParameter == HEADER_NOTIFY) {
        readNotifyMessage(messageLines);
      } else if (firstLineParameter != HEADER_M_SEARCH) {}
    }
  }

  void readSearchResponseMessage(List<String> lines) {
    final headers = parseHeader(lines);
    final usn = headers[HEADER_USN];
    if (usn?.isNotEmpty == true) {
      final location = headers[HEADER_LOCATION];
      final cache_control = headers[HEADER_CACHE_CONTROL];
      if (location?.isNotEmpty == true && cache_control?.isNotEmpty == true) {
        processAlive(usn!, location!, cache_control!);
      }
    }
  }

  void readNotifyMessage(List<String> lines) {
    final headers = parseHeader(lines);
    final usn = headers[HEADER_USN];
    if (usn?.isNotEmpty == true) {
      if (headers[HEADER_NTS] == SSDP_MSG_ALIVE) {
        final location = headers[HEADER_LOCATION];
        final cache_control = headers[HEADER_CACHE_CONTROL];
        if (location?.isNotEmpty == true && cache_control?.isNotEmpty == true) {
          processAlive(usn!, location!, cache_control!);
        }
      } else if (headers[HEADER_NTS] == SSDP_MSG_BYE_BYE) {
        processByeBye(usn!);
      }
    }
  }

  Map<String, String> parseHeader(List<String> lines) {
    Map<String, String> result = {};
    lines.forEach((element) {
      if (element.isNotEmpty) {
        var headers = element.split(': ');
        if (headers.length >= 2) {
          result[headers.first.toUpperCase()] = headers[1];
        }
      }
    });
    return result;
  }
}
