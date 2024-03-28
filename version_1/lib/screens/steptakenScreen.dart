import 'package:flutter/material.dart';

class StepTakenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff5fffa),
        title: Text(
          'Your Steps Taken',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Onest',
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // First container for displaying the icon and steps
            Container(
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                color: Color(0xffffdca7),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: screenWidth * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffede7e3),
                          ),
                          child: Icon(
                            Icons.directions_run,
                            size: 25,
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              labelText: 'STEPS',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            readOnly: true,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Steps Taken',
                          style: TextStyle(
                            fontSize: 19,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                            fontFamily: 'Onest',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Second container for displaying the runner image
            Container(
              width: screenWidth * 0.9,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color(0xffffdca7),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'assets/images/illustrationart/running.gif',
                  height: screenHeight * 0.4,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
