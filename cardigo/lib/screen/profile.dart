import 'package:flutter/material.dart';
import 'package:cardigo/utils/user_model.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  UserModel currUser = new UserModel();
/*
  String first = currUser.firstName;
  String last = currUser.lastName;
  String imageUrl = currUser.avatar;
*/

  @override
  Widget build(BuildContext context) {
    return
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.network(currUser.avatar),
          Text(currUser.firstName+" "+currUser.lastName),
        ],
      ),
    );
  }
}
