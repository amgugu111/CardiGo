import 'package:cardigo/screen/login.dart';
import 'package:cardigo/utils/statecontainer.dart';
import 'package:flutter/material.dart';
import 'package:cardigo/utils/user_model.dart';
import 'package:http/http.dart' as http;

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
            Image.network("${user.avatar}"):
            Image.network("https://gravatar.com/avatar/7dfdb904210b9f127d2fa37d956e4a6d?s=400&d=robohash&r=x"),
          user != null ?
            Text(user.firstName+" "+ user.lastName):
            Text("Hello Boss")
        ],
      ),
    );
  }
}
