import 'package:cardigo/screen/configure.dart';
import 'package:cardigo/screen/homescreen.dart';
import 'package:cardigo/screen/profile.dart';
import 'package:cardigo/screen/takesurvey.dart';
import 'package:cardigo/utils/user_model.dart';
import 'package:flutter/material.dart';

class Bottom extends StatefulWidget {

  @override
  _BottomState createState() => _BottomState();

}

class _BottomState extends State<Bottom> {

  final UserModel user;
  _BottomState({this.user});

  int _currentIndex = 0;
  final List<Widget> _children =
      [
        HomeScreen(),
        TakeSurvey(),
        ConfigureBluetooth(),
        UserProfile(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            title: Text(
              'Dashboard',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icon(Icons.dashboard),
          ),
          BottomNavigationBarItem(
            title: Text(
              'Feedback',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icon(Icons.feedback),
          ),
          BottomNavigationBarItem(
            title: Text(
              'Configure',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icon(Icons.settings_bluetooth),
          ),
          BottomNavigationBarItem(
            title: Text(
              'Profile',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icon(Icons.account_circle),
          )
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Color(0xFF86BC24),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 16,
      ),
    );
  }
}
