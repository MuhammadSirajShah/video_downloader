import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_downloader/providers/downloader_provider.dart';
import 'package:video_downloader/screens/home_screen.dart';


void main() {
  runApp(
      ChangeNotifierProvider(
          create: (_) => DownloaderProvider(),
          child:  VideoDownloaderApp(),

      ),
  );
}

class VideoDownloaderApp extends StatelessWidget {
  const VideoDownloaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Downloader',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1020),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF635BFF),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}