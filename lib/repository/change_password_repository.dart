import 'package:todo/utils/exports.dart';
import 'package:http/http.dart' as http;

class ChangePasswordRepository {
  // Future<http.Response> changePassword({
  //   required String currentPassword,
  //   required String newPassword,
  // }) async {
  //   LoginModel? loginModel = SharedPreferencesManager.getLoginModel();
  //   try {
  //     print("onlineCustomerId: ${loginModel?.customerInfo?.onlineCustomerId}");
  //     return await http.post(
  //       Uri.parse(AppUrl.register),
  //       headers: Utils.getHeaders(),
  //       body: json.encode({
  //         "onlineCustomerId": loginModel?.customerInfo?.onlineCustomerId ?? '',
  //         "currentPassword": currentPassword,
  //         "newPassword": newPassword
  //       }),
  //     );
  //   } catch (e) {
  //     throw Exception('Network error on login request: $e');
  //   }
  // }
}
