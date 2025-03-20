import 'package:todo/utils/exports.dart';

class Utils {
  static void fieldFocusChange(
    BuildContext context,
    FocusNode current,
    FocusNode next,
  ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  static flushbarErrorMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.ease,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        message: message,
        backgroundColor: AppColor.white.withOpacity(0.9),
        messageColor: AppColor.black,
        borderWidth: 3,
        borderColor: Colors.red,
        borderRadius: BorderRadius.circular(8),
        duration: const Duration(milliseconds: 2500),
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
        icon: const Icon(Icons.error, size: 28, color: AppColor.danger),
        flushbarPosition: FlushbarPosition.TOP,
      )..show(context),
    );
  }

  static flushbarSuccessMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        message: message,
        backgroundColor: Colors.green,
        borderRadius: BorderRadius.circular(8),
        duration: const Duration(seconds: 2),
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
        icon: const Icon(Icons.error, size: 28, color: Colors.white),
        flushbarPosition: FlushbarPosition.TOP,
      )..show(context),
    );
  }

  static snackbarMessage(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(message)),
    );
  }

  static bool validateAll({
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController emailController,
    required TextEditingController mobileController,
    required TextEditingController passwordController,
    required TextEditingController reenterPasswordController,
    required BuildContext context,
  }) {
    // Validate first name
    if (firstNameController.text.isEmpty) {
      Utils.flushbarErrorMessage("First name cannot be empty", context);
      return false;
    }

    // Validate last name
    if (lastNameController.text.isEmpty) {
      Utils.flushbarErrorMessage("Last name cannot be empty", context);
      return false;
    }

    // Validate email
    RegExp emailRegEx = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    if (emailController.text.isEmpty) {
      Utils.flushbarErrorMessage("Email cannot be empty", context);
      return false;
    } else if (!emailRegEx.hasMatch(emailController.text)) {
      Utils.flushbarErrorMessage("Invalid email address", context);
      return false;
    }

    // Validate mobile
    RegExp mobileRegEx = RegExp(r'(^\+?1?[0-9]{10,12}$)');
    if (mobileController.text.isEmpty) {
      Utils.flushbarErrorMessage("Mobile number cannot be empty", context);
      return false;
    } else if (!mobileRegEx.hasMatch(mobileController.text)) {
      Utils.flushbarErrorMessage("Invalid mobile number", context);
      return false;
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      Utils.flushbarErrorMessage("Password cannot be empty", context);
      return false;
    } else if (passwordController.text.length < 6) {
      Utils.flushbarErrorMessage(
        "Password must be at least 6 characters",
        context,
      );
      return false;
    }

    // Validate re-enter password
    if (reenterPasswordController.text.isEmpty) {
      Utils.flushbarErrorMessage(
        "Re-enter password field cannot be empty",
        context,
      );
      return false;
    } else if (passwordController.text != reenterPasswordController.text) {
      Utils.flushbarErrorMessage("Passwords do not match", context);
      return false;
    }

    // If all validations pass
    return true;
  }

  static bool validateLogin({
    required TextEditingController mobileController,
    required TextEditingController passwordController,
    required BuildContext context,
  }) {
    RegExp mobileRegEx = RegExp(r'(^\+?1?[0-9]{10,12}$)');
    if (mobileController.text.isEmpty) {
      Utils.flushbarErrorMessage("Mobile number cannot be empty", context);
      return false;
    } else if (!mobileRegEx.hasMatch(mobileController.text)) {
      Utils.flushbarErrorMessage("Invalid mobile number", context);
      return false;
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      Utils.flushbarErrorMessage("Password cannot be empty", context);
      return false;
    } else if (passwordController.text.length < 6) {
      Utils.flushbarErrorMessage(
        "Password must be at least 6 characters",
        context,
      );
      return false;
    }

    return true;
  }

  static bool validateChangePassword({
    required TextEditingController currentPasswordController,
    required TextEditingController newPasswordController,
    required TextEditingController reEnterNewPasswordController,
    required BuildContext context,
  }) {
    // Check if any field is empty
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        reEnterNewPasswordController.text.isEmpty) {
      Utils.flushbarErrorMessage("None of the fields can be empty", context);
      return false;
    }

    if (currentPasswordController.text.length < 6) {
      Utils.flushbarErrorMessage(
        "Current must be at least 6 characters long",
        context,
      );
      return false;
    }

    // Check if the new password matches the re-entered password
    if (newPasswordController.text != reEnterNewPasswordController.text) {
      Utils.flushbarErrorMessage("The new passwords do not match", context);
      return false;
    }

    // Check if the new password length is at least 6 characters
    if (newPasswordController.text.length < 6) {
      Utils.flushbarErrorMessage(
        "Password must be at least 6 characters long",
        context,
      );
      return false;
    }

    // If all conditions are met
    return true;
  }

  static Map<String, String> getHeaders({
    String? token,
    bool isMultipart = false,
  }) {
    Map<String, String> headers = {};

    // Add authorization header if a token is provided
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    // Set the content type based on whether the request is multipart or not
    headers['Content-Type'] =
        isMultipart ? 'multipart/form-data' : 'application/json';

    return headers;
  }

  static bool validateAddressFields({
    required TextEditingController nameController,
    required TextEditingController contactController,
    required TextEditingController addressController,
    required TextEditingController landmarkController,
    required int selectedAddressTypeId,
    required String? pickedAddress,
    required double? pickedLatitude,
    required double? pickedLongitude,
    required BuildContext context,
  }) {
    // Check if any text field is empty
    if (nameController.text.isEmpty ||
        contactController.text.isEmpty ||
        addressController.text.isEmpty ||
        landmarkController.text.isEmpty) {
      Utils.flushbarErrorMessage("All fields are required", context);
      return false;
    }

    // Validate name length
    if (nameController.text.length < 3) {
      Utils.flushbarErrorMessage(
        "Name must be at least 3 characters long",
        context,
      );
      return false;
    }

    // Validate contact number length
    RegExp mobileRegEx = RegExp(r'(^\+?1?[0-9]{10,12}$)');
    if (contactController.text.length < 10) {
      Utils.flushbarErrorMessage(
        "Contact number must be at least 10 digits long",
        context,
      );
      return false;
    } else if (mobileRegEx.hasMatch(contactController.text)) {
      Utils.flushbarErrorMessage("Invalid mobile number", context);
      return false;
    }

    // Validate address length
    if (addressController.text.length < 10) {
      Utils.flushbarErrorMessage(
        "Address must be at least 10 characters long",
        context,
      );
      return false;
    }

    // Validate selected address type
    if (selectedAddressTypeId < 1) {
      Utils.flushbarErrorMessage("Please select a valid address type", context);
      return false;
    }

    // Validate picked address
    if (pickedAddress == null || pickedAddress.isEmpty) {
      Utils.flushbarErrorMessage("Please choose location", context);
      return false;
    }

    // Validate picked latitude and longitude
    if (pickedLatitude == null || pickedLongitude == null) {
      Utils.flushbarErrorMessage(
        "Invalid location data. Please select a valid location",
        context,
      );
      return false;
    }

    // If all validations pass
    return true;
  }
}
