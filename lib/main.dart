import 'package:flutter/material.dart';

import 'features/daily_reflection/presentation/daily_reflection_screen.dart';

void main() {
  runApp(const HeartTalkApp());
}

class HeartTalkApp extends StatelessWidget {
  const HeartTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HeartTalk',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF386A5F)),
        useMaterial3: true,
      ),
      home: const DailyReflectionScreen(),
    );
  }
}
