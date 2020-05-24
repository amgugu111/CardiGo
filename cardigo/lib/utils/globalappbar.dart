import 'package:cardigo/screen/login.dart';
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
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          onPressed: ()
            => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => loginPage())),
          icon: Icon(Icons.exit_to_app),
          color: Colors.black,
          iconSize: 26,
        ),
      ],
    );
  }
}
