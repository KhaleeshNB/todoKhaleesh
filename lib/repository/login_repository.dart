import 'package:todo/utils/exports.dart';
import 'package:http/http.dart' as http;

class LoginRepository {
  Future<http.Response> login({
    required String mobileNumber,
    required String password,
  }) async {
    try {
      return await http.post(
        Uri.parse(AppUrl.login),
        headers: Utils.getHeaders(),
        body: json.encode({
          "mobile": mobileNumber,
          "password": password,
          "deviceToken": "1234",
        }),
      );
    } catch (e) {
      throw Exception('Network error on login request: $e');
    }
  }
}
