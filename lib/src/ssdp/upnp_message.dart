import 'dart:collection';

class UpnpMessage {
  static const String _serverInformation = "Linux/3.10.61+, UPnP/1.0, Portable SDK for UPnP devices/1.6.13";

  factory UpnpMessage.search(String type) => UpnpMessage(
        method: "M-SEARCH",
        header: {
          "HOST": "239.255.255.250:1900",
          "MAN": "\"ssdp:discover\"",
          "ST": type,
          "MX": "3",
        },
      );

  factory UpnpMessage.notify({
    required String usn,
    required String? nt,
    required String location,
    String server = _serverInformation,
    int cacheTime = 66,
    bool alive = true,
  }) =>
      UpnpMessage(
        method: "NOTIFY",
        header: {
          "SERVER": server,
          "LOCATION": location,
          "CACHE-CONTROL": "max-age=$cacheTime",
          "NT": nt?.isNotEmpty == true ? nt! : usn,
          "NTS": "ssdp:${alive ? "alive" : "byebye"}",
          "USN": "$usn${nt?.isNotEmpty == true ? "::$nt" : ""}",
        },
      );

  static List<UpnpMessage> buildNotifyList({
    required String usn,
    required String location,
    int cacheTime = 66,
    required List<String> ntList,
  }) =>
      ntList.map((e) => UpnpMessage.notify(usn: usn, location: location, nt: e)).toList(growable: false);

  UpnpMessage({
    required String method,
    String path = "*",
    String protocol = "HTTP/1.1",
    required Map<String, String> header,
  })  : _method = method,
        _path = path,
        _protocol = protocol {
    _headers.addAll(header);
  }

  final String _method;
  final String _path;
  final String _protocol;
  final LinkedHashMap<String, String> _headers = LinkedHashMap();

  String get data {
    StringBuffer buffer = StringBuffer();
    buffer.write("$_method $_path $_protocol\r\n");
    _headers.forEach((key, value) {
      buffer.write("$key: $value\r\n");
    });
    buffer.write("\r\n");
    return buffer.toString();
  }

  void addHeader(String name, String value) => _headers[name] = value;

  void removeHeader(String name) => _headers.remove(name);

  @override
  String toString() => data;
}
