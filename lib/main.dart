import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home.dart';
import 'static_handler.dart';
import 'login_screen.dart';
List<CameraDescription> cameras;

Future<Null> main() async {

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tflite real-time detection',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: CameraGetter(),
    );
  }
}


class CameraGetter extends StatefulWidget {
  @override
  _CameraGetterState createState() => _CameraGetterState();
}

class _CameraGetterState extends State<CameraGetter> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
         availableCameras().then((cam){
           cameras=cam;
           StaticHandler.cameras=cam;
           Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>new LoginPage()));
         });
    } on CameraException catch (e) {
      print('Error: $e.code\nError Message: $e.message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
