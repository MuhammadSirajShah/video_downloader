import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:video_downloader/screens/downloads/downloads_screen.dart';
import 'package:video_downloader/screens/settings/settings_screen.dart';
import 'package:video_downloader/screens/video_options/video_options_screen.dart';

import '../../models/video_model.dart';
import '../../services/api_service.dart';
import '../../services/url_detector.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController =
  TextEditingController();

  final ApiService _apiService = ApiService();

  String? _detectedPlatform;
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  // ==========================================
  // URL DETECTION
  // ==========================================

  void _detectUrl(String value) {
    final platform =
    UrlDetector.detectPlatform(value);

    setState(() {
      _detectedPlatform = platform;
    });
  }

  // ==========================================
  // PASTE LINK
  // ==========================================

  Future<void> _pasteLink() async {
    final text = await FlutterClipboard.paste();

    if (text.trim().isEmpty) {
      _showMessage('Clipboard is empty.');
      return;
    }

    final cleanText = text.trim();

    _urlController.text = cleanText;
    _detectUrl(cleanText);

    if (UrlDetector.detectPlatform(cleanText) == null) {
      _showMessage(
        'Unsupported or invalid video link.',
      );
    }
  }

  // ==========================================
  // DOWNLOAD BUTTON
  // ==========================================

  Future<void> _downloadPressed() async {
    final url = _urlController.text.trim();

    if (url.isEmpty) {
      _showMessage(
        'Please paste a video link first.',
      );
      return;
    }

    if (_detectedPlatform == null) {
      _showMessage(
        'This platform is not supported.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final VideoModel result =
    await _apiService.getVideoInfo(url);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result.success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              VideoOptionsScreen(
                platform: result.platform,
                videoUrl: result.sourceUrl,
                videoInfo: result,
              ),
        ),
      );
    } else {
      _showMessage(
        result.message ??
            'Unable to process this video link.',
      );
    }
  }

  // ==========================================
  // MESSAGE
  // ==========================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ==========================================
  // NAVIGATION
  // ==========================================

  void _openDownloads() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const DownloadsScreen(),
      ),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const SettingsScreen(),
      ),
    );
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),

      // ========================================
      // BODY
      // ========================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              // ==================================
              // HEADER
              // ==================================

              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(14),
                      gradient:
                      const LinearGradient(
                        colors: [
                          Color(0xFF635BFF),
                          Color(0xFF8B5CF6),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.download_rounded,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Video Downloader',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Download your favorite media',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // ==================================
              // TITLE
              // ==================================

              const Text(
                'Download Videos & Audio',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Paste a supported video link below to get started.',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 24),

              // ==================================
              // URL FIELD
              // ==================================

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF151B2D),
                  borderRadius:
                  BorderRadius.circular(16),
                  border: Border.all(
                    color:
                    _detectedPlatform != null
                        ? const Color(
                      0xFF635BFF,
                    )
                        : Colors.white10,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.link_rounded,
                      color: Color(0xFF8B7FFF),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: TextField(
                        controller:
                        _urlController,
                        onChanged: _detectUrl,
                        keyboardType:
                        TextInputType.url,
                        decoration:
                        const InputDecoration(
                          hintText:
                          'Paste video link here...',
                          hintStyle:
                          TextStyle(
                            color: Colors.white38,
                            fontSize: 14,
                          ),
                          border:
                          InputBorder.none,
                        ),
                      ),
                    ),

                    TextButton.icon(
                      onPressed: _pasteLink,
                      icon: const Icon(
                        Icons
                            .content_paste_rounded,
                        size: 18,
                      ),
                      label:
                      const Text('Paste'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ==================================
              // DETECTED PLATFORM
              // ==================================

              if (_detectedPlatform != null)
                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color:
                    const Color(0xFF151B2D),
                    borderRadius:
                    BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.3)
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons
                            .check_circle_rounded,
                        color:
                        Colors.greenAccent,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        '$_detectedPlatform link detected',
                        style:
                        const TextStyle(
                          color:
                          Colors.greenAccent,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 18),

              // ==================================
              // DOWNLOAD BUTTON
              // ==================================

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : _downloadPressed,
                  icon: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(
                    Icons
                        .download_rounded,
                  ),
                  label: Text(
                    _isLoading
                        ? 'Checking...'
                        : 'Download',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF635BFF),
                    foregroundColor:
                    Colors.white,
                    minimumSize:
                    const Size(
                      double.infinity,
                      56,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // ==================================
              // SUPPORTED PLATFORMS
              // ==================================

              const Text(
                'Supported Platforms',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
                children: const [
                  PlatformCard(
                    icon: Icons.facebook,
                    name: 'Facebook',
                  ),
                  PlatformCard(
                    icon:
                    Icons.camera_alt_outlined,
                    name: 'Instagram',
                  ),
                  PlatformCard(
                    icon:
                    Icons.music_note_rounded,
                    name: 'TikTok',
                  ),
                  PlatformCard(
                    icon: Icons
                        .chat_bubble_outline_rounded,
                    name: 'Snapchat',
                  ),
                  PlatformCard(
                    icon:
                    Icons.favorite_border_rounded,
                    name: 'Likee',
                  ),
                  PlatformCard(
                    icon:
                    Icons.play_circle_outline_rounded,
                    name: 'YouTube',
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ==================================
              // INFO
              // ==================================

              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color:
                  const Color(0xFF151B2D),
                  borderRadius:
                  BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons
                          .info_outline_rounded,
                      color:
                      Color(0xFF8B7FFF),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        'Only download content you have permission or rights to download.',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ========================================
      // BOTTOM NAVIGATION
      // ========================================

      bottomNavigationBar:
      NavigationBar(
        backgroundColor:
        const Color(0xFF0F1526),
        selectedIndex: 0,

        onDestinationSelected: (index) {
          if (index == 1) {
            _openDownloads();
          }

          if (index == 2) {
            _openSettings();
          }
        },

        destinations: const [
          NavigationDestination(
            icon:
            Icon(Icons.home_outlined),
            selectedIcon:
            Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.download_outlined,
            ),
            selectedIcon: Icon(
              Icons.download_rounded,
            ),
            label: 'Downloads',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.settings_outlined,
            ),
            selectedIcon: Icon(
              Icons.settings_rounded,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// PLATFORM CARD
// ==========================================

class PlatformCard extends StatelessWidget {
  final IconData icon;
  final String name;

  const PlatformCard({
    super.key,
    required this.icon,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151B2D),
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),

          const SizedBox(height: 8),

          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}