import 'package:flutter/services.dart';
import 'package:todo/utils/exports.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkIfUserIsLoggedIn();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkIfUserIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString('id');
    String? userName = prefs.getString('name');
    String? userEmail = prefs.getString('email');

    if (userId != null && userName != null && userEmail != null) {
      print("hi $userName, user ID: $userId");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TodosPage()),
      );
    } else {
      print("No user data found in SharedPreferences.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Login",
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50.h),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.alternate_email),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "email cannot be empty";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 50.h),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock_rounded),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "password cannot be empty";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 80.h),
                      ],
                    ),
                  ),
                  Consumer<LoginProvider>(
                    builder: (context, loginProvider, child) {
                      return RoundButton(
                        text: "Login",
                        loading: loginProvider.isLoading,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            loginProvider.login(
                              _emailController.text,
                              _passwordController.text,
                              context,
                            );
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Dont have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "SignUp",
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
