import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

void showInSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

Future<Map<String, int>> getImageDimensions(File imageFile) async {
  var decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
  return {'width': decodedImage.width, 'height': decodedImage.height};
}

Future<bool> saveImage(BuildContext context, GlobalKey key) async {
  try {
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();

    if (pngBytes != null) {
      final result =
          await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes));
      return (result != null && result);
    }
  } catch (e) {
    print('Error saving image: $e');
  }
  return false;
}

Future<int> countFaces(File imageFile) async {
  final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
    enableClassification: true,
    enableLandmarks: true,
    enableContours: true,
    enableTracking: true,
  ));

  final inputImage = InputImage.fromFile(imageFile);
  var faces = await faceDetector.processImage(inputImage);
  return faces.length;
}
