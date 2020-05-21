import 'package:cardigo/utils/statecontainer.dart';
import 'package:flutter/material.dart';
import 'package:cardigo/utils/user_model.dart';

class UserProfile extends StatefulWidget {

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserModel user;
  @override
  Widget build(BuildContext context) {
  final userInherited =  StateContainer.of(context);
  user = userInherited.user;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          user != null ?
            Image.network("${user.avatar}")
              : Image.asset("assets/avatar.png"),
          user != null ?
            Text(user.firstName+" "+ user.lastName):
            Text("Hello Boss")
        ],
      ),
    );
  }
}
