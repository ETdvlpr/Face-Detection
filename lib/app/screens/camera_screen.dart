import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:face_detection/app/screens/image_edit_screen.dart';
import 'package:face_detection/app/services/camera_service.dart';

// Define a StatefulWidget for the CameraScreen
class CameraScreen extends StatefulWidget {
  // List of available cameras
  final List<CameraDescription> cameras;

  // Constructor to initialize CameraScreen with cameras
  const CameraScreen(this.cameras, {Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

// Define the state for the CameraScreen
class _CameraScreenState extends State<CameraScreen> {
  // Service to handle camera-related functionalities
  CameraService? _cameraService;

  // ImagePicker instance for handling image selection from the gallery
  final ImagePicker _imagePicker = ImagePicker();

  // Initialize camera service when the state is created
  @override
  void initState() {
    super.initState();
    // Check if cameras are available and initialize the first one
    if (widget.cameras.isNotEmpty) {
      _cameraService = CameraService(widget.cameras[0]);
      _initializeCamera();
    }
  }

  // Initialize camera asynchronously
  void _initializeCamera() async {
    await _cameraService?.initializeCamera();
    setState(() {});
  }

  // Build the UI for the CameraScreen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildCameraPreview(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // Build the camera preview widget using FutureBuilder
  Widget _buildCameraPreview() {
    return FutureBuilder(
      future: _cameraService?.initializeCamera(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (_cameraService?.controller == null) {
            return const Center(
              child: Text(
                'Camera not found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return CameraPreview(_cameraService!.controller);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // Build the floating action button with camera-related actions
  Widget _buildFloatingActionButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: SvgPicture.asset('assets/images/capture_icon.svg'),
            onPressed: _takePicture,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.image, color: Colors.white),
                onPressed: _handleGalleryClick,
              ),
              IconButton(
                icon: SvgPicture.asset('assets/images/switch_icon.svg'),
                onPressed: _switchCamera,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Take a picture using the camera
  void _takePicture() async {
    try {
      final XFile? file = await _cameraService?.takePicture();
      if (file != null) {
        _navigateToImageEditScreen(file.path);
      }
    } catch (e) {
      print(e);
    }
  }

  // Handle the gallery button click to select an image
  void _handleGalleryClick() async {
    try {
      final XFile? galleryImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (galleryImage != null) {
        _navigateToImageEditScreen(galleryImage.path);
      }
    } catch (e) {
      print(e);
    }
  }

  // Switch between front and back cameras
  void _switchCamera() async {
    await _cameraService?.switchCamera();
    setState(() {});
  }

  // Navigate to the image editing screen with the selected image file
  void _navigateToImageEditScreen(String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageEditScreen(imageFile: File(filePath)),
      ),
    );
  }

  // Dispose of the camera service when the screen is disposed
  @override
  void dispose() {
    _cameraService?.dispose();
    super.dispose();
  }
}
