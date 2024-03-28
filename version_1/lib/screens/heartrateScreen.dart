import 'package:flutter/material.dart';

class HeartRateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5fffa),
      appBar: AppBar(
        title: Text(
          'Diagnostics',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Onest',
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height:200,
            decoration: BoxDecoration(
              color: Color(0xff82c0cc),
              borderRadius: BorderRadius.circular(30.0),
            ),
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
                    Icons.favorite,
                    size: 25,
                  ),
                ),
                SizedBox(height: 2),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'BPM',
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Onest',
                    ),
                    controller: TextEditingController(text: 'Your BPM'),
                    readOnly: true,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Heartbeat',
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
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 228, 242, 245),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'assets/images/illustrationart/hearts.gif',
                 height: 400, 
                  width: 200, 
                 fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
