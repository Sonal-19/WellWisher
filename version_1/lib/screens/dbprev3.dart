import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:version_1/screens/profileScreen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  String bpm = '0';
  String steps = '0';
  final db = FirebaseDatabase.instance.reference();

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

  // String getUserInitials() {
  //   // Get the user's name initials
  //   if (currentUser != null && currentUser!.displayName != null) {
  //     List<String> nameParts = currentUser!.displayName!.split(' ');
  //     return nameParts.length >= 2
  //         ? '${nameParts[0][0]}${nameParts[1][0]}' // First letter of first name and last name
  //         : '${nameParts[0][0]}'; // Only the first letter of the name
  //   } else {
  //     return '';
  //   }
  // }

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

  // void navigateToProfilePage() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //      builder: (context) => ProfileScreen(
  //         userEmail: currentUser!.email!,
  //         userName: '', // You need to pass the user's name here
  //         userCountry: '', // You need to pass the user's country here
  //       ),
  //     ),
  //   );
  // }

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
                        onTap: () {},
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              AssetImage('assets/images/profile/dp1.jpg'),
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


//  @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff5fffa),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: 20.0,
//                 vertical: 25,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: navigateToProfilePage,
//                     child: CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Colors.grey[300],
//                       child: Text(
//                         getUserInitials(),
//                         style: TextStyle(
//                           fontSize: 20,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Text(
//                     'Hello, ',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.black,
//                       fontFamily: 'Onest',
//                     ),
//                   ),
//                   FutureBuilder(
//                     future: getUserInfo(),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         Map<String, dynamic>? user = snapshot.data!.data();
//                         return Text(
//                           user!['fullname'],
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: Colors.black,
//                             fontFamily: 'Onest',
//                           ),
//                         );
//                       } else if (snapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return const Text("Loading...");
//                       } else if (snapshot.hasError) {
//                         return Text("Error: ${snapshot.error}");
//                       } else {
//                         return const Text("No Data");
//                       }
//                     },
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       signOutUser();
//                     },
//                     child: Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xffede7e3),
//                       ),
//                       child: Icon(
//                         Icons.logout,
//                         size: 25,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

            
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
                                          // Icon(
                                          //   Icons.favorite,
                                          //   size: 30,
                                          //   color: Colors.white,
                                          // ),
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
                                                  // borderSide: BorderSide(
                                                  //   color: Colors
                                                  //       .black, // Outline color of border
                                                  //   width:
                                                  //       2.0, // Width of the border
                                                  // ),
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
                                  // Icon(
                                  //   Icons.directions_run,
                                  //   size: 30,
                                  //   color: Colors.white,
                                  // ),
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.home),
              color: Colors.black,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite),
              color: Colors.black,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.directions_run),
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
