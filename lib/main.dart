import 'package:camera/camera.dart';
import 'package:face_detection/app/screens/camera_screen.dart';
import 'package:flutter/material.dart';

// The main entry point of the application.
void main() async {
  // Ensure that Flutter bindings are initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  // Fetch the available cameras before running the app.
  final cameras = await availableCameras();

  // Run the application by passing the list of available cameras to MyApp.
  runApp(MyApp(cameras));
}

// The main application widget.
class MyApp extends StatelessWidget {
  // List of available cameras passed to the application.
  final List<CameraDescription> cameras;

  // Constructor for MyApp that takes the list of cameras as a parameter.
  const MyApp(this.cameras, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Configure and run the MaterialApp with CameraScreen as the home widget.
    return MaterialApp(
      home: CameraScreen(cameras),
      debugShowCheckedModeBanner: false, // Disable the debug banner.
    );
  }
}
