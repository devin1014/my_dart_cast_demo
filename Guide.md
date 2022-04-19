#
SSDP - Simple Sever Discovery Protocol, 简单服务发现协议
[https://www.cnblogs.com/debin/archive/2009/12/01/1614543.html]

```dart
M-SEARCH * HTTP/1.1
HOST: 239.255.255.250:1900
MAN: "ssdp:discover"
MX: seconds to delay response
ST: search target
'''

各HTTP协议头的含义简介：
HOST：设置为协议保留多播地址和端口，必须是：239.255.255.250:1900（IPv4）或FF0x::C(IPv6)
MAN：设置协议查询的类型，必须是：ssdp:discover
MX：设置设备响应最长等待时间，设备响应在0和这个值之间随机选择响应延迟的值。这样可以为控制点响应平衡网络负载。
ST：设置服务查询的目标，它必须是下面的类型：
　　ssdp:all 搜索所有设备和服务
　　upnp:rootdevice 仅搜索网络中的根设备
　　uuid:device-UUID 查询UUID标识的设备
　　urn:schemas-upnp-org:device:device-Type:version 查询device-Type字段指定的设备类型，设备类型和版本由UPNP组织定义。
　　urn:schemas-upnp-org:service:service-Type:version 查询service-Type字段指定的服务类型，服务类型和版本由UPNP组织定义。