import 'package:flutter/material.dart';
import 'package:version_1/screens/dashBoardScreen2.dart';
import 'package:version_1/screens/heartRateScreen.dart';
import 'package:version_1/screens/stepTakenScreen.dart';
import 'package:version_1/screens/profileScreen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    DashBoardScreen(),
    HeartRateScreen(),
    StepTakenScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Heart Rate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Steps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff16697a), // Active icon color
        unselectedItemColor:const Color(0xff8bb4bd), // Inactive icon color
        onTap: _onItemTapped,
        selectedLabelStyle: TextStyle(color: const Color(0xff16697a)), // Active label color
        unselectedLabelStyle: TextStyle(color: const Color(0xff8bb4bd)), // Inactive label color
        showUnselectedLabels: true, // Show inactive labels
      ),
    );
  }
}
