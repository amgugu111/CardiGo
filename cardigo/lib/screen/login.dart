import 'package:cardigo/utils/bottom_nav.dart';
import 'package:cardigo/utils/loader.dart';
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


void showToast(String msg) {
  Fluttertoast.showToast(msg: msg,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.black,
      textColor: Colors.white);
  print("Wrong Creds");
}

// ignore: camel_case_types
class _loginPageState extends State<loginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController eIdController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  bool _obscureText = true;
  UserModel _user;
  bool isLoading = false;

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
    else if(response.statusCode == 404) {
      final String responseString = response.body;
      print(responseString);
      String wrongMsg = "No such Employee ID";
      showToast(wrongMsg);
      setState(() {
        isLoading = false;
      });
      return userModelFromJson(responseString);
    }
    else{
      String wrongMsg = "Invalid Employee ID";
      showToast(wrongMsg);
    }
  }

  isLoggedIn() async{
    final String eId = eIdController.text;
    final String password = passwordController.text;
    final UserModel user = await currentUser(eId, password);
    final userInherited = StateContainer.of(context);
    print(isLoading);
    setState(() {
      _user = user;
      print(_user.error);
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

    void validateAndSave() {
    final FormState form = _formkey.currentState;
    if(form.validate()) {
      print("Validated");
      isLoggedIn();
    }
    else {
      setState(() {
        isLoading = false;
      });
      print("Not valid");
    }
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      resizeToAvoidBottomPadding: false,
      body: isLoading ?
      Center(child:
          Container(
            height: height,
            width: width,
            child: Loader(),
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
            width: width/2.1,
            child: Image.asset("assets/hello_there.png")
          ),
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: eIdController,
                    validator: (value) {
                      if(value.isEmpty) {
                        return "Employee ID can't be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Employee ID',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    validator: (value) {
                      if(value.isEmpty) {
                        return "Password can't be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(icon: Icon(
                        _obscureText ?
                        Icons.visibility : Icons.visibility_off),
                         onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        color: Colors.grey,
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
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
                  SizedBox(height: height/25),
                  Container(
                    height: height/20,
                    width: width/1.2,
                    child: Material(
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height/50)),
                      shadowColor: Colors.grey,
                      color: Color(0xff86BC24),
                        child: Material(
                          type: MaterialType.transparency,
                          elevation: 6,
                          color: Colors.transparent,
                          shadowColor: Colors.grey,
                          child: InkWell(
                            splashColor: Colors.white30,
                            onTap: ()  {
                              setState(() {
                                isLoading = true;
                              });
                              validateAndSave();
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
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
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
