import 'dart:async';
import 'dart:convert' show json, utf8;
import 'package:cardigo/screen/alerts.dart';
import 'package:cardigo/screen/configure.dart';
import 'package:cardigo/screen/profile.dart';
import 'package:cardigo/screen/takesurvey.dart';
import 'package:cardigo/utils/globalappbar.dart';
import 'package:cardigo/utils/statecontainer.dart';
import 'package:cardigo/utils/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key key, this.device}) : super(key: key);
  final BluetoothDevice device;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ignore: non_constant_identifier_names
  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  // ignore: non_constant_identifier_names
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  bool isReady;
  Stream<List<int>> stream;
  List<double> tracePulse;
  Map feedbackSent;
  static final List<String> chartDropdownItems = [ 'Last Session', 'Last hour', 'Last day' ];
  String actualDropdown = chartDropdownItems[0];
  UserModel user;
  int actualChart = 0;
  SocketIO socketIO;

  @override
  void initState() {
    isReady = false;
    connectToDevice();
    tracePulse = List<double>();
    feedbackSent = Map();
    tracePulse = [0.0,72.0];
    //Creating the socket
    socketIO = SocketIOManager().createSocketIO(
      'https://cardigo.eu-gb.cf.appdomain.cloud','/'
    );
    //Call init before doing anything with socket
    socketIO.init();
    socketIO.subscribe('receive_pulse', (jsonData) {
      Map<double, dynamic> data = json.decode(jsonData);
      this.setState(() => tracePulse.add(data['tracepulse']),);
    });
    //Connect to the socket
    socketIO.connect();

    super.initState();
  }

  connectToDevice() async {
    if(widget.device == null){
      connectAgain();
      return;
    }
    new Timer(const Duration(seconds: 15), () {
      if(!isReady) {
        disconnectFromDevice();
        connectAgain();
      }
    });

    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice(){
    if(widget.device == null){
      connectAgain();
      return;
    }
    widget.device.disconnect();
  }

  discoverServices() async{
    if(widget.device == null){
      connectAgain();
      return;
    }
    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;

            setState(() {
              isReady = true;
            });
          }
        });
      }
    });

    if (!isReady) {
      connectAgain();
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (context) =>
        new AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to disconnect device and go back?'),
          actions: <Widget>[
            new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No')),
            new FlatButton(
                onPressed: () {
                  disconnectFromDevice();
                  Navigator.of(context).pop(true);
                },
                child: new Text('Yes')),
          ],
        ) ??
            false);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  @override
  Widget build(BuildContext context) {
    final userInherited =  StateContainer.of(context);
    user = userInherited.user;
    var appBar = new GlobalAppBar();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: Color(0xfffafafa),
        appBar: appBar,
        body: StaggeredGridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                children: <Widget>[
                  _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>
                            [
                              Text(user != null ? 'Hi ${user.firstName}, ':'Hi User',
                                  style: TextStyle(color: Colors.black87,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24.0,fontFamily: "Montserrat")),
                              Text(user != null ?'${user.designation}':'your designation',
                                  style: TextStyle(color: Colors.black45,
                                      fontSize: 16,fontFamily: "Montserrat"))
                            ],
                          ),
                          Material(
                            shadowColor: Colors.lightGreenAccent,
                            child: Center(
                              child: user != null ?
                              CircleAvatar(
                                radius: 40.0,
                                backgroundImage:
                                NetworkImage("${user.avatar}"),
                                backgroundColor: Colors.transparent,
                              )
                                  : Image.asset("assets/avatar.png"),
                            )
                          )
                        ]
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => UserProfile())),
                  ),
                  _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Material(
                                color: Colors.blueAccent,
                                shape: CircleBorder(),
                                child: Padding
                                  (
                                  padding: const EdgeInsets.all(12.0),
                                  child: Icon(Icons.people, color: Colors.white, size: 25.0),
                                )
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Team', style: TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.w700, fontSize: 20.0)),
                                  Text('Message', style: TextStyle(color: Colors.black45)),
                                ]
                            ),
                          ]
                      ),
                    ),
                  ),
                  _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Material(
                                color: Color(0xffa64452),
                                shape: CircleBorder(),
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(Icons.notifications, color: Colors.white, size: 30.0),
                                )
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Alerts', style: TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.w700, fontSize: 20.0)),
                                  Text('All ', style: TextStyle(color: Colors.black45)),
                                  ]
                            ),
                          ]
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => Alerts())),
                  ),
                  _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Material(
                                color: Colors.orangeAccent,
                                shape: CircleBorder(),
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(Icons.local_hospital, color: Colors.white, size: 30.0),
                                )
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Leaves', style: TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.w700, fontSize: 20.0)),
                                  Text('Apply ', style: TextStyle(color: Colors.black45)),
                                ]
                            ),
                          ]
                      ),
                    ),
/*                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => Alerts())),*/
                  ),
                  _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: !isReady
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:<Widget>[
                            Text("Waiting for sensor...",
                              style: TextStyle(fontSize: 24, color: Colors.black,
                                  fontFamily: 'Montserrat'
                              ),
                            ),
                            Container(
                                height: 40.0,
                                width: 250,
                                child: Material(
                                    borderRadius: BorderRadius.circular(40.0),
                                    shadowColor: Colors.lightGreenAccent,
                                    color: Color(0xFF86BC24),
                                    elevation: 7.0,
                                    child: GestureDetector(
                                      onTap: ()  {
                                        setState(() {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context)
                                              => ConfigureBluetooth()));

                                        });
                                      },
                                      child: Center(
                                        child: Text(
                                          'Configure again',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                ),
                            )
                          ]
                        )
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: StreamBuilder<List<int>>(
                                      stream: stream,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<int>> snapshot) {
                                        if (snapshot.hasError)
                                          return Text('Error: ${snapshot.error}');

                                        if (snapshot.connectionState ==
                                            ConnectionState.active) {
                                          var currentValue = _dataParser(snapshot.data);
                                          tracePulse.add(double.tryParse(currentValue) ?? 0);
                                          //sending tracepulse with socket
                                          if(tracePulse!=null){
                                            socketIO.sendMessage(
                                                'send_pulse', json.encode({'tracepulse': tracePulse}));
                                          }
                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                  children: <Widget>[
                                                    Text('Pulse Rate ',
                                                      style: TextStyle(fontSize: 16)),
                                                    Text('❤️', style: TextStyle(color:Colors.red, fontSize: 16)),
                                                  ]
                                              ),
                                              Text('$currentValue BPM',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24
                                                )
                                              )
                                            ]
                                          );
                                        } else {
                                          return Text('Check sensor');
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              DropdownButton(
                                isDense: true,
                                value: actualDropdown,
                                onChanged: (String value) => setState(() {
                                  actualDropdown = value;
                                  actualChart = chartDropdownItems.indexOf(value); // Refresh the chart
                                }),
                                items: chartDropdownItems.map((String title) {
                                  return DropdownMenuItem(
                                    value: title,
                                    child: Text(title, style: TextStyle(color: Color(0xff013220), fontWeight: FontWeight.w400, fontSize: 14.0)),
                                  );
                                }).toList()
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 15.0)),
                          tracePulse!= null ?
                          Container(
                            height: MediaQuery.of(context).size.height/4,
                            child: Sparkline(
                              data: tracePulse,
                              useCubicSmoothing: true,
                              lineWidth: 5.0,
                              lineColor: Colors.green,
                              enableGridLines: true,
                              labelPrefix: "",
                              pointsMode: PointsMode.last,
                              pointSize: 5.0,
                              pointColor: Colors.red,
//                              fillMode: FillMode.below,
                              fillGradient: new LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.green[800], Colors.green[200]],
                              ),
                            ),
                          )
                              : Center(
                            child: Text("Loading...",
                              style: TextStyle(fontSize: 24, color: Colors.black,
                                  fontFamily: 'Montserrat'
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                  _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Give Report', style: TextStyle(color: Colors.redAccent,fontFamily: "Montserrat",
                                fontSize: 15)),
                                Text('Fill the feedback', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0,
                                    fontFamily: "Montserrat"))
                              ],
                            ),
                            Material(
                                color: Colors.red,
                                shape: CircleBorder(),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Icon(Icons.feedback, color: Colors.white, size: 30.0),
                                  )
                                )
                            ),
                          ]
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => TakeSurvey())),
                  )
                ],
              staggeredTiles: [
                StaggeredTile.extent(2, 110),
                StaggeredTile.extent(1, 160),
                StaggeredTile.extent(1, 74),
                StaggeredTile.extent(1, 74),
                StaggeredTile.extent(2, 300),
                StaggeredTile.extent(2, 120),
              ],
            )
        ),
      );
  }
  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () { print('Not set yet'); },
            child: child
        )
    );
  }

  connectAgain() {
    showDialog(
      context: context,builder: (_) => AssetGiffyDialog(
        image: Image.asset(
          'assets/noconnection.gif',
          fit: BoxFit.cover,
        ),
        title: Text("Can't connect?",
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.w600,fontFamily: 'Montserrat'
          ),
        ),
        description: Text("Please configure your device first. Facing issues in pairing?"
            "Please contact Administrator",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Montserrat", fontSize: 16,
          ),
        ),
        entryAnimation: EntryAnimation.BOTTOM,
        onOkButtonPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context)
              => ConfigureBluetooth()));
        },
      )
    );
  }

  plotTrace() {
    Sparkline(
      data: tracePulse,
      useCubicSmoothing: true,
      lineWidth: 5.0,
      lineColor: Colors.blue,
      pointsMode: PointsMode.last,
      pointSize: 5.0,
      pointColor: Colors.red,
      fillMode: FillMode.below,
      fillGradient: new LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.green[800], Colors.green[200]],
      ),
    );
  }
}
