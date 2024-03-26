import 'package:flutter/material.dart';
import 'package:version_1/screens/loginScreen.dart';
import 'package:version_1/screens/registerScreen.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {

  //Initially shows Login Screen
  bool showLoginScreen = true;

  //Toggle between Login and Register Screen
  void toggleScreen(){
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen){
      return LoginScreen(onTap: toggleScreen);
    }
    else {
      return RegisterScreen(onTap: toggleScreen,);
    }
  }
}
