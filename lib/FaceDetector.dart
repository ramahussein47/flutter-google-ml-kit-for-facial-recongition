import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart'; // Add this import for UUID

class FaceDetectionProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  late CameraController _cameraController;
  bool _isDetecting = false;
  List<Face> _faces = [];
  final Set<String> _capturedFaceIds = {}; // Track captured face IDs

  List<Face> get faces => _faces;
  CameraController get cameraController => _cameraController;
  bool get isDetecting => _isDetecting;

  Future<void> initializeCamera(List<CameraDescription> cameras) async {
    final CameraDescription? frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => throw Exception("Front camera not found."),
    );

    _cameraController = CameraController(
      frontCamera!,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );

    await _cameraController.initialize();
    notifyListeners();
  }

  Future<void> captureAndDetectFaces(BuildContext context) async {
    if (_cameraController.value.isInitialized) {
      try {
        final XFile file = await _cameraController.takePicture();
        final inputImage = await _inputImageFromFilePath(file.path);

        if (inputImage != null) {
          await _detectFaces(inputImage);
          await _checkAndSaveImage(File(file.path), context);
        }
      } catch (e) {
        print("Error capturing or processing image: $e");
      }
    }
  }

  Future<void> _checkAndSaveImage(File file, BuildContext context) async {
    for (var face in _faces) {
      final String faceId = _generateFaceId(face);

      if (_capturedFaceIds.contains(faceId)) {
        _showAlreadyCapturedDialog(context);
      } else {
        _capturedFaceIds.add(faceId);
        await _saveImage(file);
        print('Image saved to ${file.path}');
      }
    }
  }

  String _generateFaceId(Face face) {
    final List<double> featurePoints = [
      face.landmarks[FaceLandmarkType.leftEye]?.position.x,
      face.landmarks[FaceLandmarkType.leftEye]?.position.y,
      face.landmarks[FaceLandmarkType.rightEye]?.position.x,
      face.landmarks[FaceLandmarkType.rightEye]?.position.y,
      face.landmarks[FaceLandmarkType.noseBase]?.position.x,
      face.landmarks[FaceLandmarkType.noseBase]?.position.y,
    ].whereType<double>().toList();

    final bytes = utf8.encode(featurePoints.join(','));
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _saveImage(File file) async {
    final directory = await getApplicationDocumentsDirectory();
    String imagePath = '${directory.path}/${file.uri.pathSegments.last}';

    int counter = 1;
    while (await File(imagePath).exists()) {
      final newFileName = '${file.uri.pathSegments.last.split('.').first}_$counter.${file.uri.pathSegments.last.split('.').last}';
      imagePath = '${directory.path}/$newFileName';
      counter++;
    }

    await file.copy(imagePath);
    print('Image saved to $imagePath');
  }

  Future<InputImage?> _inputImageFromFilePath(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return null;
    return InputImage.fromFilePath(filePath);
  }

  Future<void> _detectFaces(InputImage inputImage) async {
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        enableTracking: true,
      ),
    );

    _faces = await faceDetector.processImage(inputImage);
    faceDetector.close();
    notifyListeners();
  }

  void _showAlreadyCapturedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Image Already Captured'),
          content: Text('A picture for this person has already been taken.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

Future<void> registerStudent(String studentName, File imageFile) async {
  try {
    final uuid = Uuid(); // Create a new UUID instance
    final studentId = uuid.v4(); // Generate a unique ID
    final fileName = 'faces/${imageFile.uri.pathSegments.last}';

    // Upload the image to Supabase storage
    final storageResponse = await supabase.storage.from('Faces').upload(fileName, imageFile);

    // Ensure storageResponse is checked properly
    /*if (storageResponse.error != null) {
      throw Exception("Failed to upload image: ${storageResponse.error!.message}");
    }*/

    // Get the public URL of the uploaded image
    final imageUrl = supabase.storage.from('Faces').getPublicUrl(fileName);

    // Insert the student data into the Students table
    final response = await supabase.from('Students').insert({
      'id': studentId, // Include the student ID
      'name': studentName,
      'image_url': imageUrl,
      'registered_at': DateTime.now().toIso8601String(),
    });

    if (response.error != null) {
      throw Exception("Failed to register student: ${response.error!.message}");
    }

    print('Student "$studentName" registered successfully with ID: $studentId and image URL: $imageUrl');
  } catch (e) {
    print("Error registering student: $e");
  }
}


  Future<void> captureAndRegisterStudent(String studentName, BuildContext context) async {
    if (_cameraController.value.isInitialized) {
      try {
        final XFile file = await _cameraController.takePicture();
        final inputImage = await _inputImageFromFilePath(file.path);

        if (inputImage != null) {
          await _detectFaces(inputImage);
        }

        if (_faces.isNotEmpty) {
          await registerStudent(studentName, File(file.path));
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text('No faces detected. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('Error capturing or processing the student\'s image.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
