import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_realtime_detection/static_handler.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'bndbox.dart';
import 'coming_soon.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  List<CameraDescription> cameras;

  HomePage(){
  cameras=StaticHandler.cameras;
  }

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    String res;
    switch (_model) {
      case yolo:
        res = await Tflite.loadModel(
          model: "assets/yolov2_tiny.tflite",
          labels: "assets/yolov2_tiny.txt",
        );
        break;

      case mobilenet:
        res = await Tflite.loadModel(
            model: "assets/mobilenet_v1_1.0_224.tflite",
            labels: "assets/mobilenet_v1_1.0_224.txt");
        break;

      case posenet:
        res = await Tflite.loadModel(
            model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
        break;

      default:
        res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt");
    }
    print(res);
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    final alucard = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.only(top:48.0),
        child: Image.asset('assets/logo1.png',height: 150,),

      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Welcome to InsidAR',
        style: TextStyle(fontSize: 28.0, color: Colors.white),
      ),
    );

    final objectDetection = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {

          onSelect(ssd);
//                        ontext).pushNamed(HomePage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.white,
        child: Text('Object Detection', style: TextStyle(color: Colors.lightBlueAccent)),
      ),
    );


    final objectDetectionWIthAR = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {

          Navigator.of(context).push(new MaterialPageRoute(builder: (context){
            return ComingSoon();
          }));
//          onSelect(ssd);
//                        ontext).pushNamed(HomePage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.white,
        child: Text('Object Detection With AR', style: TextStyle(color: Colors.lightBlueAccent)),
      ),
    );
    final lorem = Padding(
      padding: EdgeInsets.all(8.0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          objectDetection,
          objectDetectionWIthAR
        ],
      )
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.blue,
          Colors.lightBlueAccent,
        ]),
      ),
      child: Column(
        children: <Widget>[alucard, welcome, lorem],
      ),
    );

    return Scaffold(
      body: _model == ""
//          ? Center(
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  RaisedButton(
//                    child: const Text("Object Detection"),
//                    onPressed: () => onSelect(ssd),
//                  ),
//                  RaisedButton(
//                    child: const Text("Object Detection with AR"),
//                    onPressed: () {
//                      Scaffold.of(context).showSnackBar(new SnackBar(
//                        content: new Text("Coming Soon"),
//                      ));
//                    },
//                  ),
////                  RaisedButton(
////                    child: const Text(yolo),
////                    onPressed: () => onSelect(yolo),
////                  ),
////                  RaisedButton(
////                    child: const Text(mobilenet),
////                    onPressed: () => onSelect(mobilenet),
////                  ),
////                  RaisedButton(
////                    child: const Text(posenet),
////                    onPressed: () => onSelect(posenet),
////                  ),
//                ],
//              ),
//            )
    ?body
          : Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                ),
                BndBox(
                    _recognitions == null ? [] : _recognitions,
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                    _model),
              ],
            ),
    );
  }
}
