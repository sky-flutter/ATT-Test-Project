abstract class ApiResponse {
  ApiResponse();

  factory ApiResponse.success(json) => BaseResponse.fromJson(json);

  factory ApiResponse.error({int statusCode = 0, String errorMessage = ""}) =>
      ErrorResponse(statusCode: statusCode, errorMessage: errorMessage);
}

class BaseResponse extends ApiResponse {
  // bool success;
  // String message;
  // int statusCode;
  dynamic results;
  dynamic data;

  BaseResponse({this.results});

  factory BaseResponse.fromJson(json) {
    return BaseResponse(results: json);
  }

  loadData(dynamic data) {
    this.data = data;
  }
}

class ErrorResponse extends ApiResponse {
  int statusCode;
  String errorMessage;

  ErrorResponse({this.statusCode = 0, this.errorMessage = ""});
}
