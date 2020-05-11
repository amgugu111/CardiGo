import 'dart:async';
import 'dart:convert' show utf8;
import 'package:cardigo/utils/globalappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:oscilloscope/oscilloscope.dart';

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
  List<double> tracePulse = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isReady = false;
    connectToDevice();
  }

  connectToDevice() async {
    if(widget.device == null){
      _Pop();
      return;
    }
    new Timer(const Duration(seconds: 15), () {
      if(!isReady) {
        disconnectFromDevice();
        _Pop();
      }
    });

    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice(){
    if(widget.device == null){
      _Pop();
      return;
    }
    widget.device.disconnect();
  }

  discoverServices() async{
    if(widget.device == null){
      _Pop();
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
      _Pop();
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

  // ignore: non_constant_identifier_names
  _Pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  @override
  Widget build(BuildContext context) {

    Oscilloscope oscilloscope = Oscilloscope(
      showYAxis: true,
      padding: 0.0,
      backgroundColor: Colors.black,
      traceColor: Colors.white,
      yAxisMax: 300,
      yAxisMin: 40,
      dataSet: tracePulse,
    );

    var appBar = new GlobalAppBar();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: appBar,
        body: Container(
            child: !isReady
                ? Center(
              child: Text(
                "Waiting...",
                style: TextStyle(fontSize: 24, color: Colors.red),
              ),
            )
                : Container(
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

                    return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Current value from Sensor',
                                        style: TextStyle(fontSize: 14)),
                                    Text('${currentValue} BPM',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24))
                                  ]),
                            ),
                            Expanded(
                              flex: 1,
                              child: oscilloscope,
                            )
                          ],
                        ));
                  } else {
                    return Text('Check the stream');
                  }
                },
              ),
            )),
      ),
    );
  }
}


