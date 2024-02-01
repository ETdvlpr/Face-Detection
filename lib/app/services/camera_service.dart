import 'package:camera/camera.dart';

class CameraService {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  CameraService(CameraDescription camera) {
    _controller = CameraController(camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  Future<void> initializeCamera() async {
    await _initializeControllerFuture;
  }

  CameraController get controller => _controller;

  Future<XFile> takePicture() async {
    await initializeCamera();
    return _controller.takePicture();
  }

  Future<void> switchCamera() async {
    final description = await _getOppositeCameraDescription();
    if (description != null) {
      await _controller.dispose();
      _controller = CameraController(description, ResolutionPreset.medium);
      _initializeControllerFuture = _controller.initialize();
    }
  }

  Future<CameraDescription?> _getOppositeCameraDescription() async {
    final cameras = await availableCameras();
    if (cameras.length < 2) return null;

    final currentCamera = _controller.description;

    for (final camera in cameras) {
      if (camera.lensDirection != currentCamera.lensDirection) {
        return camera;
      }
    }

    return null;
  }

  void dispose() {
    _controller.dispose();
  }
}
