import 'package:flutter/material.dart';

class Bottom extends StatefulWidget {
  @override
  _BottomState createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          title: Text(
            'Dashboard',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: Icon(Icons.dashboard),
        ),
        BottomNavigationBarItem(
          title: Text(
            'Survey Center',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: Icon(Icons.assignment),
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
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,

    );
  }
}
