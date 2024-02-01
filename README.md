# Face Detection

Face Detection is a Flutter app that allows users to capture or load images, edit them by adding green areas to specific facial features, and finalize the image for download. The app utilizes Flutter packages for camera integration, image editing, and face detection.

## Overview

Face Detection provides a user-friendly interface for capturing or selecting images, editing them with green areas on specific facial features, and saving the edited image to the device gallery.

## Screenshots

Include screenshots or images showcasing different parts of your app.

## Installation

Follow these steps to install and run the app on your local machine:

```bash
# Clone the repository
git clone <repository-url>

# Navigate to the project folder
cd face_detection

# Get dependencies
flutter pub get

# Run the app
flutter run
```

## Features

- **Camera Integration**: Open the camera by default when the app starts.
- **Image Editing**: Add green areas to eyes and mouth for facial features.
- **Face Detection**: Detect faces and show a toast message for more than two faces.
- **Save to Gallery**: Save the edited image to the device gallery.

## Technologies Used

- Flutter
- `camera` package for camera integration
- `image_picker` package for image selection
- `google_mlkit_face_detection` for face detection
- `image_gallery_saver` package for saving images to the gallery

## Usage

1. Open the app and use the camera or gallery to select an image.
2. Edit the image by adding green areas to eyes and mouth.
3. Finalize the image and save it to the gallery.

## Contributing

Feel free to contribute to the project. Follow these steps:

1. Fork the repository.
2. Create a new branch.
3. Make your changes.
4. Submit a pull request.

## License

This project is licensed under the MIT license - see the [LICENSE.md](LICENSE.md) file for details.
