import 'package:cardigo/utils/bottom_nav.dart';
import 'package:cardigo/utils/globalappbar.dart';
import 'package:flutter/material.dart';

class TakeSurvey extends StatefulWidget {
  @override
  _TakeSurveyState createState() => _TakeSurveyState();
}

class _TakeSurveyState extends State<TakeSurvey> {
  final appBar = new GlobalAppBar();
  final bottomBar = new Bottom();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Text("Feedback"),
      ),
    );
  }
}
