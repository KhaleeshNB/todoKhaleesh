// import 'package:todo/model/login_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferencesManager {
//   static SharedPreferences? _preferences;

//   static const String loginResponseKey = "loginResponse";

//   static Future initialize() async {
//     _preferences = await SharedPreferences.getInstance();
//   }

//   static Future setLoginResponse(String json) async {
//     await _preferences?.setString(loginResponseKey, json);
//   }

//   static String? getLoginResponse() {
//     return _preferences?.getString(loginResponseKey);
//   }

//   static LoginModel? getLoginModel() {
//     final jsonString = getLoginResponse();
//     if (jsonString != null) {
//       return loginModelFromJson(jsonString);
//     }
//     return null;
//   }

//   static Future<void> clearAll() async {
//     await _preferences?.clear();
//   }
// }
