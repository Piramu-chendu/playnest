import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(const PlayNestApp());
}

class PlayNestApp extends StatelessWidget {
  const PlayNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlayNest',
      home: const SplashScreen(),
    );
  }
}
