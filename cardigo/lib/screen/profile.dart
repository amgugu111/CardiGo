import 'package:cardigo/utils/globalappbar.dart';
import 'package:cardigo/utils/statecontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cardigo/utils/user_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class UserProfile extends StatefulWidget {

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserModel user;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final userInherited =  StateContainer.of(context);
    final appBar = new GlobalAppBar();
    user = userInherited.user;
    return Scaffold(
        backgroundColor: Color(0xfffafafa),
      appBar: appBar,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget>[
          Flexible(
            fit: FlexFit.loose,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: height/8,
                    width: height/8,
                    decoration: BoxDecoration(
                      color: Color(0xfffafafa),
                      boxShadow: [BoxShadow(color: Color(0xffced4da),
                          blurRadius: 15)],
                      image: DecorationImage(
                        image: user != null ?
                        NetworkImage("${user.avatar}")
                            : AssetImage("assets/avatar.png"),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(user != null ? user.firstName+" "+ user.lastName
                      : "Hello Boss",
                  style: TextStyle(color: Colors.black87,fontSize: height/45,
                  fontFamily: "Montserrat",fontWeight: FontWeight.w500,
                  letterSpacing: 1.2),),
                  SizedBox(
                    height: 5,
                  ),
                  Text(user != null ? "${user.employeeId}"
                      : "No ID",
                    style: TextStyle(color: Colors.black54,fontSize: height/55,
                        fontFamily: "Montserrat"
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(user != null ? "${user.email}"
                      : "No Email",
                    style: TextStyle(color: Colors.black54,fontSize: height/60,
                        fontFamily: "Montserrat"
                    ),
                  ),
                ],
              ),
            ),
          ),
            Container(
              height: MediaQuery.of(context).size.height/2.2,
              decoration: BoxDecoration(
                color: Color(0xff343a40),
                  /*boxShadow: [BoxShadow(color: Color(0xffadb5bd),
                      blurRadius: 15)],*/
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(40),
                  topRight: const Radius.circular(40)
                )
              ),
              child: StaggeredGridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: MediaQuery.of(context).size.height/40,
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/14,
                    vertical: MediaQuery.of(context).size.height/26),
                children: <Widget>[
                  _buildTile(
                    Padding(
                      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/14,
                          10, MediaQuery.of(context).size.width/14, 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Material(
                                shadowColor: Colors.grey,
                                elevation: 5,
                                color: Color(0xffe57373),
                                borderRadius: BorderRadius.circular(16.0),
                                child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(height/90),
                                      child: Image.asset("assets/icons/deadline.png"),
                                    )
                                )
                            ),
                            Text('Deadlines', style: TextStyle(color: Color(0xffe57373),
                                fontFamily: "Montserrat", fontSize: height/50,fontWeight: FontWeight.w700)),
                            Container(
                              height: height/30,
                              width: height/30,
                              decoration: new BoxDecoration(
                                  boxShadow: [BoxShadow(color: Colors.grey,
                                      blurRadius: 5)],
                                  shape: BoxShape.circle,
                                  color: Colors.black38
                              ),
                              child: Center(
                                child: Icon(Icons.arrow_forward_ios,
                                  color: Colors.white,
                                size: height/45,),
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                  _buildTile(
                    Padding(
                      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/14,
                          10, MediaQuery.of(context).size.width/14, 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Material(
                                shadowColor: Colors.grey,
                                elevation: 5,
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(16.0),
                                child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(height/90),
                                      child: Image.asset("assets/icons/message.png"),
                                    )
                                )
                            ),
                            Text('Messages', style: TextStyle(color: Color(0xffff8f00),
                                fontFamily: "Montserrat", fontSize: height/50, fontWeight: FontWeight.w700)),
                            Container(
                              height: height/30,
                              width: height/30,
                              decoration: new BoxDecoration(
                                boxShadow: [BoxShadow(color: Colors.grey,
                                      blurRadius: 5)],
                                shape: BoxShape.circle,
                                color: Colors.black38
                              ),
                              child: Center(
                                child: Icon(Icons.arrow_forward_ios,
                                  color: Colors.white,
                                    size: height/45),
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                  _buildTile(
                    Padding(
                      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/14,
                          10, MediaQuery.of(context).size.width/14, 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Material(
                                shadowColor: Colors.grey,
                                elevation: 5,
                                color: Color(0xff64b5f6),
                                borderRadius: BorderRadius.circular(16.0),
                                child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(height/90),
                                      child: Image.asset("assets/icons/payslip.png"),
                                    )
                                )
                            ),
                            Text('Pay Slips', style: TextStyle(color: Color(0xff1565c0),
                                fontFamily: "Montserrat", fontSize: height/50,fontWeight: FontWeight.w700)),
                            Container(
                              height: height/30,
                              width: height/30,
                              decoration: new BoxDecoration(
                                  boxShadow: [BoxShadow(color: Colors.grey,
                                      blurRadius: 5)],
                                  shape: BoxShape.circle,
                                  color: Colors.black38
                              ),
                              child: Center(
                                child: Icon(Icons.arrow_forward_ios,
                                  color: Colors.white,
                                    size: height/45),
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                  _buildTile(
                    Padding(
                      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/14,
                          10, MediaQuery.of(context).size.width/14, 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Material(
                                shadowColor: Colors.grey,
                                elevation: 5,
                                color: Color(0xff80cbc4),
                                borderRadius: BorderRadius.circular(16.0),
                                child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(height/90),
                                      child: Image.asset("assets/icons/refund.png"),
                                    )
                                )
                            ),
                            Text('Reimbursements', style: TextStyle(color: Color(0xff009688),
                                fontFamily: "Montserrat", fontSize: height/50, fontWeight: FontWeight.w700)),
                            Container(
                              height: height/30,
                              width: height/30,
                              decoration: new BoxDecoration(
                                  boxShadow: [BoxShadow(color: Colors.grey,
                                      blurRadius: 5)],
                                  shape: BoxShape.circle,
                                  color: Colors.black38
                              ),
                              child: Center(
                                child: Icon(Icons.arrow_forward_ios,
                                  color: Colors.white,
                                    size: height/45),
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
                  staggeredTiles: [
                    StaggeredTile.extent(2, MediaQuery.of(context).size.width/7.7),
                    StaggeredTile.extent(2, MediaQuery.of(context).size.width/7.7),
                    StaggeredTile.extent(2, MediaQuery.of(context).size.width/7.7),
                    StaggeredTile.extent(2, MediaQuery.of(context).size.width/7.7),]
              ),//
            ),
        ]
      )
    );
  }
  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 7.0,
        borderRadius: BorderRadius.circular(18.0),
        shadowColor: Colors.grey,
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () { print('Not set yet'); },
            child: child
        )
    );
  }
}