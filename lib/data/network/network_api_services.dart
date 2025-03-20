import 'package:todo/utils/exports.dart';
import 'package:http/http.dart' as http;

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getGetApiResponse(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    }
  }

  @override
  Future<dynamic> getPostApiResponse(String url, dynamic data) async {
    try {
      final response = await http
          .post(Uri.parse(url), body: jsonEncode(data))
          .timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        Map<String, dynamic> errorData = jsonDecode(response.body);
        String errorMessage = errorData['message'] ?? "An error occurred";
        return errorMessage;
      // throw BadRequestException(jsonDecode(response.body)['message']);
      default:
        throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode : ${response.statusCode}',
        );
    }
  }
}
