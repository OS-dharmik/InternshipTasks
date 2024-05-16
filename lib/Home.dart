// ignore_for_file: file_names, use_key_in_widget_constructors, annotate_overrides, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:internship1task/Loginpage.dart';
import 'package:internship1task/TaskFive.dart';
import 'package:internship1task/TaskFour.dart';
import 'package:internship1task/TaskSix.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isConnected = true;

  Future<void> _checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        _isConnected = connectivityResult != ConnectivityResult.none;
      });
    }
  }

  void initState() {
    super.initState();
    _checkInternet();
    Connectivity().onConnectivityChanged.listen((result) {
      _checkInternet();
    });
  }

  final List<int> taskNumbers = [1, 2, 3, 4, 5, 6];

  @override
  Widget build(BuildContext context) {
    return _isConnected
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                "Internship Task",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.blue,
              elevation: 0,
            ),
            backgroundColor: Colors
                .lightGreen[100], // Set pistachio green color as background
            body: GridView.builder(
              padding: EdgeInsets.all(20),
              itemCount: taskNumbers.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {
                      navigateToTaskPage(context, taskNumbers[index]);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blue.shade200,
                            Colors.blue,
                            Colors.blue.shade500,
                            Colors.blue.shade700,
                            Colors.blue.shade800,
                            Colors.blue.shade900
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Task${taskNumbers[index]}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        : _buildAlertDialog();
  }

  Widget _buildAlertDialog() {
    return AlertDialog(
      title: Text('No Internet Connection'),
      content: Text('Please check your internet connection.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

void navigateToTaskPage(BuildContext context, int taskNumber) {
  switch (taskNumber) {
    case 4:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Task4()),
      );
      break;
    case 1:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      break;
    case 2:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      break;
    case 5:
      Navigator.push(context, MaterialPageRoute(builder: (context) => Task5()));
      break;
    case 6:
      Navigator.push(context, MaterialPageRoute(builder: (context) => Task6()));
      break;
    default:
      // Do something if task number is not handled
      break;
  }
}
