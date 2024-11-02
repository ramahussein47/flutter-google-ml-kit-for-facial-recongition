import 'package:facial/Registering_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:facial/FaceDetector.dart';
import 'package:facial/Homepage.dart';
import 'package:facial/bottomspage.dart';
import 'package:facial/firebase_options.dart';
import 'package:facial/pages/Login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Supabase.initialize(
 url: 'https://exlmbdyshkhqkibirtcw.supabase.co',
 anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV4bG1iZHlzaGtocWtpYmlydGN3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA1ODA5NzMsImV4cCI6MjA0NjE1Njk3M30.AISO6BD_878Ih6LeJxGwjO7-vte-ZrxC0WgMznl_2ck',
);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomPagesProvider()),
        ChangeNotifierProvider(create: (_) => FaceDetectionProvider()),
      ],
      child: const Facial(),
    ),
  );
}

class Facial extends StatelessWidget {
  const Facial({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Homepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
