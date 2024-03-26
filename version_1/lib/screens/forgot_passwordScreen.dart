import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:version_1/components/mybutton.dart';
import 'package:version_1/components/mytextfields.dart';
import 'package:version_1/services/auth_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  //text editing controller
  final _emailidController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  // void dispose() {
  //   _emailidController.dispose();
  //   super.dispose();
  // }
  //
  // Future passwordReset() async {
  //   try {
  //     await FirebaseAuth.instance
  //         .sendPasswordResetEmail(email: _emailidController.text.trim()
  //     );
  //     showErrorMessage('Password reset link sent!');
  //   } on FirebaseAuthException catch (e){
  //     showErrorMessage(e.code.toString());
  //   }
  // }

  void showErrorMessage(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )
          ),
        ),
        backgroundColor: Color(0xffd30001),
        dismissDirection: DismissDirection.up,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 120,
            left: 25,
            right: 25
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Color(0xff16697a),
        elevation: 0,
        // leading: const BackButton(
        //   color: Color(0xff2A5794),
        // ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 300, width: double.infinity,
                  child: Image.asset('assets/images/illustrationart/forgotpass.png')),


              const Text(
                  'Forgot Password',
                style: TextStyle(
                    color: Color(0xff0b090a),
                    fontSize: 40,
                  fontFamily: 'LogoFont',
                ),
              ),
              const SizedBox(height: 25,),


              MyTextField(
                  controller: _emailidController,
                  hintText: 'Email Address',
                  obscureText: false),
              const SizedBox(height: 25,),


              MyButton(
                  onTap: () async{

                    var email = _emailidController.text.trim();
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: email)
                          .then((value) => {
                            showErrorMessage('Email Sent'),
                            Navigator.of(context).pop(),
                      });
                      // showErrorMessage('Password reset link sent!');
                    } on FirebaseAuthException catch (e){
                      showErrorMessage(e.code.toString());
                    }
                  },
                  // onTap: passwordReset,
                  buttonColor: Color(0xff16697a),
                  buttonTextColor: Colors.white,
                  text: 'Get Verification Link'),
            ],
          ),
        ),
      ),
    );
  }
}
