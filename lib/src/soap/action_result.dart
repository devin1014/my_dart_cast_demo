class ActionResult<T> {
  final int code;
  String httpContent;
  T? result;
  Exception? exception;

  ActionResult.success({required this.code, required this.httpContent}) : exception = null;

  ActionResult.error({this.code = -1, this.httpContent = "", required this.exception});

  bool get success => code >= 200 && code <= 299 && httpContent.isNotEmpty;

  @override
  String toString() => "ActionResult {code: $code, httpContent: $httpContent}";
}
