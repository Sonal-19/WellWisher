import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:version_1/components/smart_device_box.dart';



class DashBoardScreen2 extends StatefulWidget {
  const DashBoardScreen2({super.key});

  @override
  State<DashBoardScreen2> createState() => _DashBoardScreenState2();
}

class _DashBoardScreenState2 extends State<DashBoardScreen2> {


  // Sign out User Method
  void signOutUser(){
    FirebaseAuth.instance.signOut();
  }

  //GET USER DETAILS
  final User? currentUser = FirebaseAuth.instance.currentUser;
  Future<DocumentSnapshot<Map<String,dynamic>>> getUserInfo() async{
    return await FirebaseFirestore.instance
        .collection('UsersData')
        .doc(currentUser!.email)
        .get();
  }


  // list of smart devices
  List mySmartDevices = [
    // [ smartDeviceName, iconPath , powerStatus ]
    ["Smart Light", "assets/images/icons/lightbulb.png", false],
    ["Smart Light", "assets/images/icons/lightbulb.png", false],
  ];

  // bool statusvalue=false;
  // getStatusofswitches(int index){
  //     statusvalue = FirebaseDatabase.instance
  //         .ref('Appliances/Switch0$index')
  //         .onValue
  //         .listen((DatabaseEvent event){
  //           event.snapshot.value;
  //         }) as bool;
  //     powerSwitchChanged(statusvalue, index);
  // }

  // power button switched
  void powerSwitchChanged(bool value, int index) {
    setState(() {
      mySmartDevices[index][2] = value;
      FirebaseDatabase.instance.ref('Appliances/Switch0$index')
          .child('Switch0$index')
          .set(value);
    });
  }

  // //SIMPLE BUTTON TOGGLE
  // bool value = false;
  // onUpdate(){
  //   setState(() {
  //     value = !value;
  //   });
  // }
  //


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
        backgroundColor: const Color(0xffd30001),
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

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   Navigator.pop(context);
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5fffa),
      body: SafeArea(
        child: Column(
          children: [
            //CUSTOM APP BAR
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                vertical: 25,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/icons/menu.png',
                    height: 45,
                    color: Colors.grey[800],
                  ),
                  GestureDetector(
                    onTap: (){
                      signOutUser();
                    },
                    child: Icon(
                      Icons.person,
                      size: 45,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),

            //WELCOME HOME USER
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Welcome Home',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade800,
                  ),
                ),
                FutureBuilder(
                    future: getUserInfo(),
                    builder: (context, snapshot){
                      if (snapshot.hasData){
                        Map<String,dynamic>?user = snapshot.data!.data();
                        return Text(
                          user!['fullname'],
                          style: GoogleFonts.bebasNeue(
                              fontSize: 72
                          ),
                        );
                      }
                      else if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading...");
                      }
                      else if (snapshot.hasError){
                        return Text("Error: ${snapshot.error}");
                      }
                      else {
                        return const Text("No Data");
                      }
                    },
                ),
              ],
            ),
            const SizedBox(height: 25),

            //DIVIDER
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Divider(
                thickness: 1,
                color: Color.fromARGB(255, 204, 204, 204),
              ),
            ),
            const SizedBox(height: 25),

            // SMART DEVICES NAME
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                  'Smart Devices',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10,),

            // SMART DEVICES + GRIDS LAYOUT
            Expanded(
              child: GridView.builder(
                itemCount: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.3,
                  ),
                  itemBuilder: (context, index){
                    return SmartDeviceBox(
                      smartDeviceName: mySmartDevices[index][0],
                      iconPath: mySmartDevices[index][1],
                      powerOn_Off: mySmartDevices[index][2],
                      onChanged: (value) => powerSwitchChanged(value, index),
                    );
                  }
              ),
            ),

          ],
        ),
      ),
    );
  }
}
