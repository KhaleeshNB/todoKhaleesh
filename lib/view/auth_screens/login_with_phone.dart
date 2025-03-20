import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/utils/exports.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        title: Text("login with phone", style: TextStyle(color: Colors.white)),
        leading: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            SizedBox(height: 30),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(hintText: "Enter Phone Number"),
            ),
            SizedBox(height: 30),
            RoundButton(
              text: "Verify",
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                auth.verifyPhoneNumber(
                  phoneNumber: phoneController.text.toString(),
                  verificationCompleted: (_) {
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (e) {
                    setState(() {
                      loading = false;
                    });
                    Utils.flushbarErrorMessage(e.toString(), context);
                  },
                  codeSent: (verificationId, forceResendingToken) {
                    setState(() {
                      loading = false;
                    });
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => VerifyCode(
                    //         verificationId: verificationId,
                    //       ),
                    //     ));
                  },
                  codeAutoRetrievalTimeout: (e) {
                    setState(() {
                      loading = false;
                    });
                    Utils.flushbarErrorMessage(e.toString(), context);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
