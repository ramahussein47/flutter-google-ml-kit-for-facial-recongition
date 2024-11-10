import 'package:camera/camera.dart';
import 'package:facial/FaceDetector.dart';
import 'package:flutter/material.dart';

class RegisterStudentPage extends StatefulWidget {
  const RegisterStudentPage({super.key});

  @override
  State<RegisterStudentPage> createState() => _RegisterStudentPageState();
}

class _RegisterStudentPageState extends State<RegisterStudentPage> {
  final FaceDetectionProvider _faceDetectionProvider = FaceDetectionProvider();
  final studentController = TextEditingController();
  late Future<void> _initializeCameraFuture;

  @override
  void initState() {
    super.initState();
    _initializeCameraFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Initialize the cameras in the FaceDetectionProvider
    final cameras = await availableCameras();
    await _faceDetectionProvider.initializeCamera(cameras);
  }

  // Function to register the student's face and name
  void _registerStudent() async {
    final studentName = studentController.text.trim();
    if (studentName.isNotEmpty) {
      await _faceDetectionProvider.captureAndRegisterStudent(studentName, context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student registered successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the student\'s name')),
      );
    }
  }

  @override
  void dispose() {
    studentController.dispose();
    _faceDetectionProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Student")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: studentController,
              decoration: const InputDecoration(labelText: 'Student Name'),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<void>(
              future: _initializeCameraFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_faceDetectionProvider.cameraController);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _registerStudent,
              child: const Text("Register a New Student"),
            ),
          ),
        ],
      ),
    );
  }
}
