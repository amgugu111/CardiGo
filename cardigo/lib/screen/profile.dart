import 'package:flutter/material.dart';
import 'package:cardigo/utils/user_model.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  final UserModel user = new UserModel();

  @override
  Widget build(BuildContext context) {
    return
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.network(user.avatar),
          Text(user.firstName+" "+user.lastName),
        ],
      ),
    );
  }
}
