import 'package:cardigo/screen/homescreen.dart';
import 'package:cardigo/utils/bottom_nav.dart';
import 'package:cardigo/utils/statecontainer.dart';
import 'package:cardigo/utils/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:giffy_dialog/giffy_dialog.dart';

// ignore: camel_case_types
class loginPage extends StatefulWidget {

  @override
  _loginPageState createState() => _loginPageState();
}

// ignore: missing_return
Future<UserModel> currentUser(String eId, String password) async{
  final String dbUrl = "https://536b9159-b453-404d-b7d5-a9513293dc75-bluemix.cloudant.com/employee-details-cardigo/"+eId;
  print(dbUrl);
  final response = await http.get(dbUrl);
  var code = response.statusCode;
  print(code);
  if(response.statusCode == 200){
    final String responseString = response.body;
    return userModelFromJson(responseString);
  }
  else{
    String wrongMsg = "Invalid Employee ID";
    showToast(wrongMsg);
  }
}

void showToast(String msg) {
  Fluttertoast.showToast(msg: msg,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.black,
      textColor: Colors.white);
  print("Wrong Creds");
}

// ignore: camel_case_types
class _loginPageState extends State<loginPage> {

  final TextEditingController eIdController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  UserModel _user;
  bool isLoading = false;

  isLoggedIn() async{
    final String eId = eIdController.text;
    final String password = passwordController.text;
    final UserModel user = await currentUser(eId, password);
    final userInherited = StateContainer.of(context);
    print(isLoading);
    setState(() {
      _user = user;
      if(_user.password == password.trim()) {
        setState(() {
          userInherited.updateUserInfo(id:_user.id, employeeId:_user.employeeId,
              password: _user.password, email: _user.email, designation: _user.designation,
              firstName:_user.firstName, lastName: _user.lastName, avatar: _user.avatar,
              pulseData: _user.pulseData, hofData:_user.hofData,
              blueStatus: _user.blueStatus,);
          isLoading = false;
          print(isLoading);
          Navigator.push(context,
              MaterialPageRoute(builder: (context)
              => Bottom()));
        });
      }
      else {
        setState(() {
          isLoading = false;
        });
        String wrongMsg = "Wrong ID/Password";
        showToast(wrongMsg);
      }
    });
  }

  String validatePassword(String value) {
    if (!(value.length > 5) && value.isNotEmpty) {
      return "ID should contains more then 5 character";
    }
    else if(value.isEmpty){
      return "ID can't be empty";
    }
    return null;
  }

  customDialog(){
    showDialog(
      context: context,builder: (_) => AssetGiffyDialog(
      onlyOkButton: true,
        buttonOkColor: Color(0xff86BC24),
        image: Image.asset(
          'assets/dialog.gif',
          fit: BoxFit.cover,
        ),
        title: Text("Can't login?",
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.w600,fontFamily: 'Montserrat'
          ),
        ),
        description: Text("Please contact your administrator, you can't "
            "register yourself as it has to be allowed by Deloitte",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Montserrat", fontSize: 16,
          ),
        ),
        entryAnimation: EntryAnimation.BOTTOM,
        onOkButtonPressed: () {
          Navigator.pop(context);
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      resizeToAvoidBottomPadding: false,
      body: isLoading ?
      Center(child:
        Container(
/*          width: double.infinity,
          height: double.infinity,*/
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                Color(0xFF86BC24)
            ),
          ),
        ),
      )
      : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width/2.1,
            child: Image.asset("assets/hello_there.png")
          ),
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: eIdController,
                  decoration: InputDecoration(
                      errorText: validatePassword(eIdController.text),
                      labelText: 'Employee ID',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green))),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green))),
                  obscureText: true,
                ),
                SizedBox(height: 5.0),
                Container(
                  alignment: Alignment(1.0, 0.0),
                  padding: EdgeInsets.only(top: 15.0, left: 20.0),
                  child: InkWell(
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Color(0xFF86BC24),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        decoration: TextDecoration.underline),
                    ),
                    onTap: () {
                      customDialog();
                    },
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                  height: 50.0,
                  width: 420,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.grey,
                    color: Color(0xFF212121),
                    elevation: 14.0,
                    child: GestureDetector(
                      onTap: ()  {
                        setState(() {
                          isLoading = true;
                        });
                        isLoggedIn();
                      },
                      child: Center(
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            )
          ),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Couldn't Login?",
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              SizedBox(width: 5.0),
              InkWell(
                child: Text(
                  'Contact Admin',
                  style: TextStyle(
                    color: Color(0xFF86BC24),
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
                ),
                onTap: () {
                  customDialog();
                },
              )
            ],
          )
        ],
      )
    );
  }
}
