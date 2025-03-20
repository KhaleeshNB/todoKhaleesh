// import 'package:todo/data/shared_preferences_manager.dart';
// import 'package:todo/model/login_model.dart';

// class SessionManager {
//   // Check if the online customer ID is present
//   static Future<bool> hasValidSession() async {
//     LoginModel? loginModel = SharedPreferencesManager.getLoginModel();
//     return loginModel?.customerInfo != null &&
//         loginModel?.customerInfo!.onlineCustomerId != null;
//   }

//   static Future<String?> getCustomerId() async {
//     LoginModel? loginModel = SharedPreferencesManager.getLoginModel();
//     return loginModel?.customerInfo?.onlineCustomerId;
//   }
// }
