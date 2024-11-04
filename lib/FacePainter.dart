import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceMeshPainter extends CustomPainter {
  final List<Face> faces;

  FaceMeshPainter(this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    for (var face in faces) {
      // Draw lines between key landmarks to create a mesh
      _drawFaceMesh(canvas, paint, face);
    }
  }

  void _drawFaceMesh(Canvas canvas, Paint paint, Face face) {
    final leftEye = face.landmarks[FaceLandmarkType.leftEye]?.position;
    final rightEye = face.landmarks[FaceLandmarkType.rightEye]?.position;
    final noseBase = face.landmarks[FaceLandmarkType.noseBase]?.position;
    final leftCheek = face.landmarks[FaceLandmarkType.leftCheek]?.position;
    final rightCheek = face.landmarks[FaceLandmarkType.rightCheek]?.position;
    final mouthLeft = face.landmarks[FaceLandmarkType.leftMouth]?.position;
    final mouthRight = face.landmarks[FaceLandmarkType.rightMouth]?.position;

    // Draw lines to connect the landmarks
    if (leftEye != null && rightEye != null) {
      canvas.drawLine(
        Offset(leftEye.x.toDouble(), leftEye.y.toDouble()),
        Offset(rightEye.x.toDouble(), rightEye.y.toDouble()),
        paint,
      );
    }
    if (noseBase != null) {
      if (leftEye != null) {
        canvas.drawLine(
          Offset(leftEye.x.toDouble(), leftEye.y.toDouble()),
          Offset(noseBase.x.toDouble(), noseBase.y.toDouble()),
          paint,
        );
      }
      if (rightEye != null) {
        canvas.drawLine(
          Offset(rightEye.x.toDouble(), rightEye.y.toDouble()),
          Offset(noseBase.x.toDouble(), noseBase.y.toDouble()),
          paint,
        );
      }
      if (mouthLeft != null) {
        canvas.drawLine(
          Offset(mouthLeft.x.toDouble(), mouthLeft.y.toDouble()),
          Offset(noseBase.x.toDouble(), noseBase.y.toDouble()),
          paint,
        );
      }
      if (mouthRight != null) {
        canvas.drawLine(
          Offset(mouthRight.x.toDouble(), mouthRight.y.toDouble()),
          Offset(noseBase.x.toDouble(), noseBase.y.toDouble()),
          paint,
        );
      }
    }
    if (leftCheek != null && mouthLeft != null) {
      canvas.drawLine(
        Offset(leftCheek.x.toDouble(), leftCheek.y.toDouble()),
        Offset(mouthLeft.x.toDouble(), mouthLeft.y.toDouble()),
        paint,
      );
    }
    if (rightCheek != null && mouthRight != null) {
      canvas.drawLine(
        Offset(rightCheek.x.toDouble(), rightCheek.y.toDouble()),
        Offset(mouthRight.x.toDouble(), mouthRight.y.toDouble()),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FaceMeshPainter oldDelegate) {
    return oldDelegate.faces != faces;
  }
}
