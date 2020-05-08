import 'package:cardigo/screen/homescreen.dart';
import 'package:cardigo/utils/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:cardigo/screen/splash.dart';
import 'package:cardigo/utils/constant.dart';

void main() => runApp(MyApp());

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
        HOME_SCREEN: (BuildContext context) => HomeApp(),
      },
    );
  }
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: HomeScreen(),
      bottomNavigationBar: Bottom(),
    );
  }
}