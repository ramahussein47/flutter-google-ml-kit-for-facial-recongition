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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 4.3,
        title: const Text('Face Detection'),
      ),
      body: Consumer<FaceDetectionProvider>(
        builder: (context, faceProvider, child) {
          if (!faceProvider.cameraController.value.isInitialized) {
            return const Center(child: CircularProgressIndicator(color: Colors.blue));
          }

          return Stack(
            children: [
              CameraPreview(faceProvider.cameraController),
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
          bool? confirmed = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Capture Face"),
                content: const Text("Do you want to capture the detected face?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text("Capture"),
                  ),
                ],
              );
            },
          );

          if (confirmed == true) {
            Provider.of<FaceDetectionProvider>(context, listen: false)
                .captureAndDetectFaces(context);
          } else {
            print('Capture canceled');
          }
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
