import 'package:cardigo/utils/user_model.dart';
import 'package:flutter/material.dart';

class StateContainer extends StatefulWidget {
  final Widget child;
  final UserModel user;

  StateContainer({@required this.child, this.user});

  static StateContainerState of(BuildContext context){
    return(context.inheritFromWidgetOfExactType(InheritedContainer) as InheritedContainer).data;
  }

  StateContainerState createState() => StateContainerState();
}

class StateContainerState extends State<StateContainer> {

  UserModel user;

  // ignore: missing_return
  Future updateUserInfo({id, employeeId,password,email,designation,firstName,
    lastName,avatar,pulseData,hofData,blueStatus,feedbackReport}){
    if(user == null) {
      user = new UserModel(id:id, employeeId:employeeId,password:password,
          email:email,designation:designation,firstName:firstName,
          lastName:lastName,avatar:avatar,pulseData:pulseData,hofData:hofData,
          blueStatus:blueStatus,feedbackReport:feedbackReport);
      setState(() {
        user = user;
      });
    }
    else {
      setState(() {
        user.id = id ?? user.id;
        user.employeeId = employeeId ?? user.employeeId;
        user.password = password ?? user.password;
        user.email = email ?? user.email;
        user.designation = designation ?? user.designation;
        user.firstName = firstName ?? user.firstName;
        user.lastName = lastName ?? user.lastName;
        user.avatar=avatar ?? user.avatar;
        user.pulseData = pulseData ?? user.pulseData;
        user.hofData = hofData ?? user.hofData;
        user.blueStatus = blueStatus ?? user.blueStatus;
        user.feedbackReport = feedbackReport ?? user.feedbackReport;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedContainer(
      data: this,
      child: widget.child,
    );
  }
}

class InheritedContainer extends InheritedWidget {
  final StateContainerState data;

  InheritedContainer({Key key,@required this.data, @required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify( InheritedContainer oldWidget) {
    return true;
  }
}