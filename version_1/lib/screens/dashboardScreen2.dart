import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:version_1/screens/heartrateScreen.dart';
import 'package:version_1/screens/steptakenScreen.dart';
import 'profileScreen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  String bpm = '0';
  String steps = '0';
  String? _profileImageUrl;
  final db = FirebaseDatabase.instance.reference();
  int _selectedIndex = 0;

  void signOutUser() {
    FirebaseAuth.instance.signOut();
  }

  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfo() async {
    return await FirebaseFirestore.instance
        .collection('UsersData')
        .doc(currentUser!.email)
        .get();
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color(0xffd30001),
        dismissDirection: DismissDirection.up,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 120,
          left: 25,
          right: 25,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    activateListeners();
    _fetchProfileImageUrl();
  }

  activateListeners() {
    db.child('Values/BPM').onValue.listen((event) {
      final String bpmValue = event.snapshot.value.toString();
      setState(() {
        bpm = bpmValue;
      });
    });
    db.child('Values').child('Steps').onValue.listen((event) {
      final String stepsValue = event.snapshot.value.toString();
      setState(() {
        steps = stepsValue;
      });
    });
  }

  // Fetch profile image URL from Firestore and update _profileImageUrl
  Future<void> _fetchProfileImageUrl() async {
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance
            .collection('UsersData')
            .doc(currentUser!.email)
            .get();

    setState(() {
      _profileImageUrl = userSnapshot.data()!['profileImageUrl'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5fffa),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 25,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          child: _profileImageUrl != null
                              ? CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    _profileImageUrl!,
                                  ),
                                )
                              : FutureBuilder(
                                  future: getUserInfo(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.waiting ||
                                        !snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      print("Error: ${snapshot.error}");
                                      return Icon(Icons.error);
                                    } else {
                                      Map<String, dynamic>? userData =
                                          snapshot.data!.data();
                                      if (userData != null &&
                                          userData
                                              .containsKey('profileImageUrl')) {
                                        return CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                            userData['profileImageUrl'],
                                          ),
                                        );
                                      } else {
                                        String initials = userData!['fullname']
                                                [0]
                                            .toUpperCase();
                                        return Text(
                                          initials,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontFamily: 'Onest',
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Hello, ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Onest',
                        ),
                      ),
                      FutureBuilder(
                        future: getUserInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Map<String, dynamic>? user = snapshot.data!.data();
                            return Text(
                              user!['fullname'],
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Onest',
                              ),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Loading...");
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            return const Text("No Data");
                          }
                        },
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      signOutUser();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffede7e3),
                      ),
                      child: Icon(
                        Icons.logout,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Text(
                'Tracker Metrics',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Onest',
                ),
              ),
            ),

// -----------------------HEART RATE---------------------------------------
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.h,
                  vertical: 25.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xff82c0cc),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xff82c0cc),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontFamily: 'Onest',
                                              ),
                                              controller: TextEditingController(
                                                  text: bpm),
                                              readOnly: true,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Heartbeat',
                                            style: TextStyle(
                                              fontSize: 19,
                                              // fontWeight:FontWeight.w400,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.black,
                                              fontFamily: 'Onest',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: Image.asset(
                                            // 'assets/images/illustrationart/heartrt.gif',
                                            'assets/images/illustrationart/cardht.gif',
                                            height: double.infinity,
                                            
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

//-------------- STEPS TAKEN----------------
                    SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xffffdca7),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.asset(
                                    'assets/images/illustrationart/run.gif',
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
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
                                  SizedBox(height: 2),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                          labelText: 'STEPS',
                                          labelStyle: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2.0))),
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      controller:
                                          TextEditingController(text: steps),
                                      readOnly: true,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Steps Taken',
                                    style: TextStyle(
                                      fontSize: 19,
                                      // fontWeight:FontWeight.w400,
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
                    ),
                  
                  ],
                ),
              ),
            ),
          
          ],
        ),
      ),

      //------- Footer------
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10.0),
        // padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: BottomAppBar(
            color: Color.fromARGB(255, 164, 238, 201),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedIndex == 0 ? Colors.white : Colors.grey,
                      ),
                      child: Icon(
                        Icons.home,
                        size: 25,
                        color:
                            _selectedIndex == 0 ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HeartRateScreen(),
                        ),
                      );
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedIndex == 1 ? Colors.white : Colors.grey,
                      ),
                      child: Icon(
                        Icons.favorite,
                        size: 25,
                        color:
                            _selectedIndex == 1 ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StepTakenScreen(),
                        ),
                      );
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedIndex == 2 ? Colors.white : Colors.grey,
                      ),
                      child: Icon(
                        Icons.directions_run,
                        size: 25,
                        color:
                            _selectedIndex == 2 ? Colors.black : Colors.white,
                      ),
                    ),
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
