import 'package:facial/FaceDetector.dart';
import 'package:facial/FacePainter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

class FaceDetectionScreen extends StatefulWidget {
  @override
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<FaceDetectionProvider>(context, listen: false);
      final cameras = await availableCameras();
      await provider.initializeCamera(cameras);
    });
  }

  Future<String?> _showStudentNameDialog() async {
    String? studentName;

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();

        return AlertDialog(
          title: const Text("Enter Student's Name"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Student's Name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                studentName = nameController.text;
                Navigator.of(context).pop(studentName);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 4.3,
        title: const Text('Face Detection'),
      ),
      body: Consumer<FaceDetectionProvider>(
        builder: (context, faceProvider, child) {
          if (!faceProvider.cameraController!.value.isInitialized) {
            return const Center(child: CircularProgressIndicator(color: Colors.blue));
          }

          return Stack(
            children: [
              CameraPreview(faceProvider.cameraController!),

              // Display the status message in the center
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    faceProvider.status,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              if (faceProvider.faces.isNotEmpty)
                CustomPaint(
                  painter: FaceMeshPainter(faceProvider.faces),
                  child: Container(),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          String? studentName = await _showStudentNameDialog();

          if (studentName != null && studentName.isNotEmpty) {

            bool? confirmed = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Capture Face"),
                  content: Text("Do you want to capture the detected face for $studentName?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Capture"),
                    ),
                  ],
                );
              },
            );

            if (confirmed == true) {
              // Capture and register the student's face with the provided name
              Provider.of<FaceDetectionProvider>(context, listen: false)
                  .captureAndRegisterStudent(studentName, context);
            } else {
              print('Capture canceled');
            }
          } else {
            // Handle the case where the student name is not provided
            print('Student name not provided');
          }
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
