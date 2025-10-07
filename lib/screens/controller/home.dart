import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../helpers/dimintions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _bulbImgPathLivingRoom = "assets/images/light_off.png";
  String _padlockImgPathFrontDoor = "assets/images/locked.png";

  Color _clrButtonLivingRoom = Colors.green;
  Color _clrButtonFrontDoor = Colors.green;

  String _txtButtonLivingRoom = "Turn on";
  String _txtButtonFrontDoor = "Unlock";

  late BluetoothConnection connection;

  String _connectedYesNo = "Loading...";
  Color _colorConnectedYesNo = Colors.black;
  String _txtButtonCheckReload = "Check";

  _MyHomePageState() {
    _connect();
  }

  bool get isConnected => (connection.isConnected);

  Future<void> _connect() async {
    try {
      connection = await BluetoothConnection.toAddress("00:19:09:01:1B:3C");
      Fluttertoast.showToast(msg: 'Connected to the Bluetooth device');
      print('Connected to the Bluetooth device');

      // Listen for incoming data
      connection.input?.listen((Uint8List data) {
        String receivedData = utf8.decode(data);
        print('Received data: $receivedData');
        // Handle the received data (e.g., verify acknowledgment)
      });

      setState(() {
        _connectedYesNo = "Connected.";
        _colorConnectedYesNo = Colors.green;
        _txtButtonCheckReload = "Check";
      });
    } catch (exception) {
      try {
        if (isConnected) {
          Fluttertoast.showToast(msg: 'Already connected to the device');
          print('Already connected to the device');
          setState(() {
            _connectedYesNo = "Connected.";
            _colorConnectedYesNo = Colors.green;
            _txtButtonCheckReload = "Check";
          });
        } else {
          Fluttertoast.showToast(msg: 'Cannot connect, exception occurred');
          print('Cannot connect, exception occurred');
          setState(() {
            _connectedYesNo = "Not connected!";
            _colorConnectedYesNo = Colors.red;
            _txtButtonCheckReload = "Reload";
          });
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: 'Cannot connect, probably not initialized connection');
        print('Cannot connect, probably not initialized connection');
        setState(() {
          _connectedYesNo = "Not connected!";
          _colorConnectedYesNo = Colors.red;
          _txtButtonCheckReload = "Reload";
        });
      }
    }
  }

  void waitLoading() {
    setState(() {
      _connectedYesNo = "Loading...";
      _colorConnectedYesNo = Colors.black;
      _txtButtonCheckReload = "Check";
    });
  }

  void _reloadOrCheck() {
    waitLoading();
    _connect();
  }

  Future<void> _sendData(String data) async {
    if (isConnected) {
      connection.output
          .add(Uint8List.fromList(utf8.encode(data))); // Sending data
      await connection.output.allSent;
      print('Data sent: $data');

      // You may want to wait for an acknowledgment from the module
      // This is an example of how to wait and verify
      Future.delayed(Duration(seconds: 1), () {
        // Check if acknowledgment received
        // Update your logic as needed
      });
    } else {
      Fluttertoast.showToast(msg: 'Not connected.');
    }
  }

  void _setLightOrLockState(String _roomOrDoorType) {
    if (_connectedYesNo == "Connected.") {
      setState(() {
        if (_roomOrDoorType == "Living Room") {
          if (_bulbImgPathLivingRoom == "assets/images/light_off.png" &&
              _clrButtonLivingRoom == Colors.green &&
              _txtButtonLivingRoom == "Turn on") {
            _bulbImgPathLivingRoom = "assets/images/light_on.png";
            _clrButtonLivingRoom = Colors.red;
            _txtButtonLivingRoom = "Turn off";
            _sendData('l');
          } else {
            _bulbImgPathLivingRoom = "assets/images/light_off.png";
            _clrButtonLivingRoom = Colors.green;
            _txtButtonLivingRoom = "Turn on";
            _sendData('L');
          }
        } else if (_roomOrDoorType == "Front Door") {
          if (_padlockImgPathFrontDoor == "assets/images/locked.png" &&
              _clrButtonFrontDoor == Colors.green &&
              _txtButtonFrontDoor == "Unlock") {
            _padlockImgPathFrontDoor = "assets/images/unlocked.png";
            _clrButtonFrontDoor = Colors.red;
            _txtButtonFrontDoor = "Lock";
            _sendData("C");
          } else {
            _padlockImgPathFrontDoor = "assets/images/locked.png";
            _clrButtonFrontDoor = Colors.green;
            _txtButtonFrontDoor = "Unlock";
            _sendData("O");
          }
        }
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Cannot send data!\nYou are not connected.',
      );
    }
  }

  Widget _buildRow(String _roomOrDoorType, String _imagePath, Color _clrButton,
      String _txtButton) {
        final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    double spacesHeight(double number) {
      final space = (number / heightRatio) * height;
      return space;
    }

    double spacesWidth(double number) {
      final space = (number / widthRatio) * width;
      return space;
    }
    return Container(
      width: 342,
      height: 154,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade200,),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Image.asset(
            _imagePath,
            height: 50.0,
            width: 50.0,
          ),
          Expanded(
              child:
                  Text(_roomOrDoorType, style: const TextStyle(fontSize: 20))),
          SizedBox(
            width: 100.0,
            child: ElevatedButton(
              onPressed: () {
                _setLightOrLockState(_roomOrDoorType);
              },
              child: Text(
                _txtButton,                
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(_clrButton)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Center(child: Text("Home")),
      ),
      body: Container(
        height: double.infinity,
                width: double.infinity,
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.fill,
          )),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildRow("Living Room", _bulbImgPathLivingRoom,
                  _clrButtonLivingRoom, _txtButtonLivingRoom),
              _buildRow("Front Door", _padlockImgPathFrontDoor,
                  _clrButtonFrontDoor, _txtButtonFrontDoor),
              Container(
                margin:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                padding: const EdgeInsets.fromLTRB(45.0, 10.0, 50.0, 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(_connectedYesNo,
                            style: TextStyle(
                                fontSize: 20, color: _colorConnectedYesNo))),
                    InkWell(
                      onTap: _reloadOrCheck,
                      child: Container(
                        width: 100.0,
                        height: 50,
                        decoration: BoxDecoration(
                          color:  Colors.blue.shade200,
                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Center(
                          child: Text(
                            _txtButtonCheckReload,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
