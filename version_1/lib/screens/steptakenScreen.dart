import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';

class StepTakenScreen extends StatefulWidget {
  const StepTakenScreen({Key? key}) : super(key: key);

  @override
  State<StepTakenScreen> createState() => _StepTakenScreenState();
}

class _StepTakenScreenState extends State<StepTakenScreen> {
  String steps = '0';
  final db = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    activateListeners();
  }

  activateListeners() {
    db.child('Values').child('Steps').onValue.listen((event) {
      final String stepsValue = event.snapshot.value.toString();
      setState(() {
        steps = stepsValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          // backgroundColor: Color.fromARGB(255, 246, 182, 250),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Padding(
            padding: EdgeInsets.only(
              top: 30.h,
              bottom: 30.h,
              left: 30.h,
              right: 30.h,
            ),
            child: Text(
              'Running Tracker',
              style: TextStyle(
                fontSize: 30.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Onest',
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 246, 182, 250),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.h),
                      Container(
                        margin: EdgeInsets.only(top: 10.h),
                        child: Text(
                          'Stride Ahead',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Onest',
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.all(10.w),
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: 'STEPS',
                            labelStyle: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.w),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.w,
                              ),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          controller: TextEditingController(text: steps),
                          readOnly: true,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Steps Taken',
                        style: TextStyle(
                          fontSize: 19.sp,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                          fontFamily: 'Onest',
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.all(10.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.w),
                          child: Image.asset(
                            'assets/images/illustrationart/run.png',
                            height: 300.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
