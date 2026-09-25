import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'providers/downloader_provider.dart';
import 'screens/home_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final downloaderProvider =
  DownloaderProvider();

  await downloaderProvider.loadDownloads();

  runApp(
    ChangeNotifierProvider.value(
      value: downloaderProvider,
      child: const VideoDownloaderApp(),
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
        scaffoldBackgroundColor:
        const Color(0xFF0B1020),
        colorScheme:
        ColorScheme.fromSeed(
          seedColor:
          const Color(0xFF635BFF),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}