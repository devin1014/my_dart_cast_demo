// ignore_for_file: constant_identifier_names

const DLNA_URN_SCHEMAS_UPNP_ORG_SERVICE = "urn:schemas-upnp-org:service";
const DLNA_SERVICE_AV_TRANSPORT = "$DLNA_URN_SCHEMAS_UPNP_ORG_SERVICE:AVTransport:1";
const DLNA_SERVICE_CONNECTION_MANAGER = "$DLNA_URN_SCHEMAS_UPNP_ORG_SERVICE:ConnectionManager:1";
const DLNA_SERVICE_RENDERING_CONTROL = "$DLNA_URN_SCHEMAS_UPNP_ORG_SERVICE:RenderingControl:1";

enum UpnpSchema {
  urn_schemas_upnp_org,
}

enum UpnpSchemaType {
  service,
  serviceId,
  device,
}

enum DeviceType {
  rootdevice,
  MediaRenderer,
  other,
}

enum ServiceType {
  AVTransport,
  ConnectionManager,
  RenderingControl,
}

class DLNAProtocol {
  static const int protocolVersion = 1;
  static const String urnSchemas = "urn:schemas-upnp-org";

  DLNAProtocol._();

  static String getDeviceType(String type) => _hasSchema(type) ? type : "$urnSchemas:device:$type:$protocolVersion";

  static String getServiceType(String type) => _hasSchema(type) ? type : "$urnSchemas:service:$type:$protocolVersion";

  static String getServiceId(String type) => _hasSchema(type) ? type : "$urnSchemas:serviceId:$type";

  static bool _hasSchema(String value) => value.startsWith(urnSchemas);
}
