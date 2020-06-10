import 'package:cardigo/screen/homescreen.dart';
import 'package:cardigo/screen/login.dart';
import 'package:cardigo/screen/takesurvey.dart';
import 'package:cardigo/screen/test.dart';
import 'package:cardigo/utils/bottom_nav.dart';
import 'package:cardigo/utils/statecontainer.dart';
import 'package:flutter/material.dart';
import 'package:cardigo/screen/splash.dart';
import 'package:cardigo/utils/constant.dart';

void main() => runApp(StateContainer(
    child: MyApp()
));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardiGo.',
      theme: ThemeData(primaryIconTheme: IconThemeData(color: Colors.black), primaryColor: Colors.black,
      appBarTheme: AppBarTheme(color: Colors.black,iconTheme: IconThemeData(color:Colors.white),)),
      home: AnimatedSplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        SPLASH_SCREEN: (BuildContext context) => AnimatedSplashScreen(),
        LOGIN_SCREEN: (BuildContext context) => loginPage(),
        BOTTOM_NAV: (BuildContext context) => Bottom(),
      },
    );
  }
}

