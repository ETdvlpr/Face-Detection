import 'dart:io';
import 'package:face_detection/app/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

// A stateful widget for editing images with facial features
class ImageEditScreen extends StatefulWidget {
  final File imageFile; // Input image file for editing

  // Constructor for ImageEditScreen widget
  const ImageEditScreen({super.key, required this.imageFile});

  // Create and return the state for ImageEditScreen
  @override
  ImageEditScreenState createState() => ImageEditScreenState();
}

// State class for the ImageEditScreen widget
class ImageEditScreenState extends State<ImageEditScreen> {
  // Define initial parameters for facial features
  double mouthWidth = 66.0;
  double mouthHeight = 30.0;
  Offset mouthPosition = const Offset(135.0, 100.0);
  Color greenColor = const Color(0x8001FF0B);
  bool isMouthVisible = false;
  Offset eyesPosition = const Offset(110.0, 70.0);
  double eyeWidth = 45.0;
  double eyeHeight = 26.0;
  bool areEyesVisible = false;
  final GlobalKey boundaryKey = GlobalKey(); // GlobalKey for RepaintBoundary
  bool multipleFacesDetected =
      true; // Flag indicating if multiple faces are detected

  // Initialize state
  @override
  void initState() {
    super.initState();
    // Count faces in the provided image and update the state
    countFaces(widget.imageFile).then((count) {
      setState(() {
        multipleFacesDetected = count > 1;
      });
    });
  }

  // Build the main UI for the ImageEditScreen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color
      appBar: AppBar(
        leading: CloseButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: RepaintBoundary(
              key: boundaryKey,
              child:
                  buildPhotoViewGallery(), // Build the interactive photo view gallery
            ),
          ),
          buildBackButton(), // Build the back button
          multipleFacesDetected
              ? const SizedBox(height: 32.0)
              : buildToggleButtons(), // Build toggle buttons for facial features
          multipleFacesDetected
              ? const SizedBox(height: 48.0)
              : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: !isMouthVisible || !areEyesVisible
                              ? null
                              : () {
                                  saveImage(context, boundaryKey).then(
                                      (value) => (value)
                                          ? showInSnackBar(
                                              context, 'Image saved to gallery')
                                          : showInSnackBar(context,
                                              'Failed to save image to gallery'));
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B8FF7),
                            disabledBackgroundColor: const Color(0xFFD3D3D3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text('저장하기'),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  // Build the interactive photo view gallery with facial features overlays
  Widget buildPhotoViewGallery() {
    return Stack(
      children: [
        PhotoViewGallery.builder(
          itemCount: 1,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: FileImage(widget.imageFile),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              initialScale: PhotoViewComputedScale.contained,
              heroAttributes: PhotoViewHeroAttributes(tag: "tag$index"),
            );
          },
          scrollPhysics: const BouncingScrollPhysics(),
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          pageController: PageController(),
        ),
        if (multipleFacesDetected) buildMultipleFacesError(),
        if (isMouthVisible)
          buildPositionedGestureDetector(
            position: mouthPosition,
            onPanUpdate: (details) {
              setState(() {
                mouthPosition += details.delta;
              });
            },
            child: buildMouthContainer(),
          ),
        if (areEyesVisible)
          buildPositionedGestureDetector(
            position: eyesPosition,
            onPanUpdate: (details) {
              setState(() {
                eyesPosition += details.delta;
              });
            },
            child: buildEyesContainer(),
          ),
        // Second eye
        if (areEyesVisible)
          buildPositionedGestureDetector(
            position: Offset(eyesPosition.dx + 70, eyesPosition.dy),
            onPanUpdate: (details) {
              setState(() {
                eyesPosition += details.delta;
              });
            },
            child: buildEyesContainer(),
          ),
      ],
    );
  }

  // Build a positioned gesture detector for handling user input on facial features
  Widget buildPositionedGestureDetector({
    required Offset position,
    required GestureDragUpdateCallback onPanUpdate,
    required Widget child,
  }) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: onPanUpdate,
        child: child,
      ),
    );
  }

  // Build the container for the mouth feature
  Widget buildMouthContainer() {
    return Container(
      width: mouthWidth,
      height: mouthHeight,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: greenColor,
        borderRadius: BorderRadius.circular(mouthHeight / 2),
      ),
    );
  }

  // Build the container for the eyes feature
  Widget buildEyesContainer() {
    return Container(
      width: eyeWidth,
      height: eyeHeight,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(eyeHeight / 2),
        color: greenColor,
      ),
    );
  }

  // Build the back button with SVG icon
  Widget buildBackButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/back.svg',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 4),
            const Text(
              "다시찍기",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // Build toggle buttons for enabling/disabling facial features
  Widget buildToggleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          buildToggleButton(
            text: '눈',
            onTap: () {
              setState(() {
                areEyesVisible = !areEyesVisible;
              });
            },
          ),
          const SizedBox(width: 16.0),
          buildToggleButton(
            text: '입',
            onTap: () {
              setState(() {
                isMouthVisible = !isMouthVisible;
              });
            },
          ),
        ],
      ),
    );
  }

  // Build a toggle button with a specified text and onTap callback
  Widget buildToggleButton(
      {required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
        ),
        child: Text(text),
      ),
    );
  }

  // Build an error message for detecting multiple faces
  buildMultipleFacesError() {
    return Positioned(
      top: 16,
      left: MediaQuery.of(context).size.width / 2 - 120,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        color: Colors.black.withOpacity(0.4),
        child: const Text(
          '2개 이상의 얼굴이 감지되었어요!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
