import 'package:facial/Registering_screen.dart';
import 'package:facial/pages/Loginpage.dart';
import 'package:facial/pages/Passwordviewer.dart';
import 'package:facial/pages/ThemeProvider.dart';
import 'package:facial/pages/TimeReports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:facial/FaceDetector.dart';
import 'package:facial/Homepage.dart';
import 'package:facial/bottomspage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomPagesProvider()),
        ChangeNotifierProvider(create: (_) => FaceDetectionProvider()),
        ChangeNotifierProvider(create: (_) => Themeprovider()),
        ChangeNotifierProvider(create: (_) => Passwordviewer()),
        ChangeNotifierProvider(create:(_)=> TimePeriodProvider()),
      ],
      child: const Facial(),
    ),
  );
}

class Facial extends StatelessWidget {
  const Facial({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Themeprovider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: LoginPage(),
        );
      },
    );
  }
}
