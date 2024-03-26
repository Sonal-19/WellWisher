import 'package:flutter/material.dart';

class MyButton extends StatelessWidget{
  final Function()? onTap;
  final Color buttonColor;
  final Color buttonTextColor;
  final String text;

  const MyButton({
    super.key,
    required this.onTap,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(color: buttonColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(text,
          style: TextStyle(
            color: buttonTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),),
        ),
      ),
    );
  }

}