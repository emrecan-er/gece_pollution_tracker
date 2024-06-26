import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';

class AirQualityPrediction extends StatefulWidget {
  final String photoPath;

  const AirQualityPrediction({Key? key, required this.photoPath})
      : super(key: key);

  @override
  State<AirQualityPrediction> createState() => _AirQualityPredictionState();
}

class _AirQualityPredictionState extends State<AirQualityPrediction> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModule();
    log(widget.photoPath);
  }

  loadModule() async {}

  List? result;

  /*Future classifyImage() async {
    result = null;
    await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/labels.txt");
    var output = await Tflite.runModelOnImage(
      path: widget.photoPath,
      numResults: 13,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      result = output;
    });
    inspect(result);
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Air Quality Predict'),
      ),
      body: Center(
        child: Image.file(
          File(widget.photoPath),
          // İlgili fotoğrafı göstermek için
        ),
      ),
    );
  }
}
