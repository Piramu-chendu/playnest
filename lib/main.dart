import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Make the status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const PlayNestApp());
}

class PlayNestApp extends StatelessWidget {
  const PlayNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlayNest',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF09050F),
        fontFamily: 'Roboto',
        splashColor: Colors.white10,
        highlightColor: Colors.white10,
      ),
      home: const SplashScreen(),
    );
  }
}
