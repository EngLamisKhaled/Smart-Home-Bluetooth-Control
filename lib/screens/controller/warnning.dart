import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WarningScreen extends StatefulWidget {
  const WarningScreen({super.key});

  @override
  State<WarningScreen> createState() => _WarningScreenState();
}

class _WarningScreenState extends State<WarningScreen> {
  late BluetoothConnection connection;
  bool _isConnecting = true;
  bool _isConnected = false;

  String _connectedYesNo = "Loading...";
  Color _colorConnectedYesNo = Colors.black;
  String _txtButtonCheckReload = "Check";

  Future<void> _connect() async {
    try {
      connection = await BluetoothConnection.toAddress("00:19:09:01:1B:3C");
      Fluttertoast.showToast(msg: 'Connected to the Bluetooth device');
      print('Connected to the Bluetooth device');

      setState(() {
        _isConnected = true;
        _connectedYesNo = "Connected.";
        _colorConnectedYesNo = Colors.green;
        _txtButtonCheckReload = "Check";
      });

      // Listen for incoming data
      connection.input?.listen((Uint8List data) {
        String receivedData = utf8.decode(data);
        print('Received data: $receivedData');
        // Handle the received data (e.g., verify acknowledgment)
      }).onDone(() {
        print('Disconnected by remote');
        setState(() {
          _isConnected = false;
          _connectedYesNo = "Disconnected!";
          _colorConnectedYesNo = Colors.red;
          _txtButtonCheckReload = "Reload";
        });
      });
    } catch (exception) {
      Fluttertoast.showToast(msg: 'Cannot connect, exception occurred');
      print('Cannot connect, exception occurred');
      setState(() {
        _isConnected = false;
        _connectedYesNo = "Not connected!";
        _colorConnectedYesNo = Colors.red;
        _txtButtonCheckReload = "Reload";
      });
    }
  }

  Future<void> _sendData(String data) async {
    if (_isConnected) {
      connection.output.add(Uint8List.fromList(utf8.encode(data))); // Sending data
      await connection.output.allSent;
      print('Data sent: $data');
    } else {
      Fluttertoast.showToast(msg: 'Not connected.');
    }
  }

  void _handleWarning() async {
    if (!_isConnected) {
      await _connect();
    }
    if (_isConnected) {
      _sendData('W');
    }
  }

  @override
  void initState() {
    super.initState();
    _connect(); // Attempt to connect when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Text("Buzzer", style: TextStyle(fontSize: 40)),
            SizedBox(height: 20),
            InkWell(
              onTap: _handleWarning,
              child: Container(
                width: 100.0,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Center(
                  child: Text(
                    "Warning",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(_connectedYesNo, style: TextStyle(color: _colorConnectedYesNo, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    connection.dispose(); // Dispose the connection when the widget is destroyed
    super.dispose();
  }
}
