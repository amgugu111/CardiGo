import 'package:flutter/material.dart';

class GlobalAppBar extends StatefulWidget implements PreferredSizeWidget  {

  @override
  _GlobalAppBarState createState() => _GlobalAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class _GlobalAppBarState extends State<GlobalAppBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_ios),
        color: Colors.black,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Image.asset('assets/cardigo_logo.png',height: 30.0,
        fit: BoxFit.scaleDown,),
      /*Text('CardiGo',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.black)
      ),*/
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          onPressed: (){
          },
          icon: Icon(Icons.settings),
          color: Colors.black,
        ),
      ],
    );
  }
}