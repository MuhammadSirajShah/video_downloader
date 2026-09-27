import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:video_downloader/screens/video_options/video_options_screen.dart';

import '../../models/video_model.dart';
import '../../services/api_service.dart';
import '../../services/url_detector.dart';
import 'downloads/downloads_screen.dart';
import 'settings/settings_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();

  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _detectedPlatform;

  final List<Map<String, dynamic>> _platforms = [
    {
      'name': 'TikTok',
      'icon': Icons.music_note_rounded,
    },
    {
      'name': 'Instagram',
      'icon': Icons.camera_alt_rounded,
    },
    {
      'name': 'Facebook',
      'icon': Icons.facebook_rounded,
    },
    {
      'name': 'YouTube',
      'icon': Icons.play_arrow_rounded,
    },
    {
      'name': 'Snapchat',
      'icon': Icons.chat_bubble_rounded,
    },
    {
      'name': 'Like',
      'icon': Icons.favorite_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _urlController.addListener(
      _handleUrlChanged,
    );
  }

  @override
  void dispose() {
    _urlController.removeListener(
      _handleUrlChanged,
    );
    _urlController.dispose();
    super.dispose();
  }

  void _handleUrlChanged() {
    final platform =
    UrlDetector.detectPlatform(
      _urlController.text,
    );
    if (_detectedPlatform == platform) {
      return;
    }
    setState(() {
      _detectedPlatform = platform;
    });
  }

  Future<void> _pasteUrl() async {
    final text = await FlutterClipboard.paste();
    if (!mounted) {
      return;
    }
    if (text.trim().isEmpty) {
      _showMessage(
        'Clipboard is empty.',
      );
      return;
    }
    _urlController.text = text.trim();
    _urlController.selection = TextSelection.collapsed(
          offset: _urlController.text.length,
        );
  }

  void _clearUrl() {
    _urlController.clear();
    setState(() {
      _detectedPlatform = null;
    });
  }

  Future<void> _getVideoInfo() async {
    if (_isLoading) {
      return;
    }
    final url =
    _urlController.text.trim();
    if (url.isEmpty) {
      _showMessage(
        'Please paste a video URL first.',
      );
      return;
    }
    final platform = UrlDetector.detectPlatform(url);
    if (platform == null) {
      _showMessage(
        'Unsupported platform or invalid URL.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _detectedPlatform = platform;
    });

    final VideoModel videoInfo = await _apiService.getVideoInfo(url);

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    if (!videoInfo.success) {
      _showMessage(
        videoInfo.message ??
            'Unable to get video information.',
      );
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => VideoOptionsScreen(
              platform: platform,
              videoUrl: url,
              videoInfo: videoInfo,
            ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
  }

  Widget _buildPlatformCard(
      Map<String, dynamic> platform,
      ) {
    final name = platform['name'] as String;

    final icon = platform['icon'] as IconData;

    final isSelected = _detectedPlatform == name;

    return Container(
      width: 105,
      padding:
      const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF635BFF)
            : const Color(0xFF151B2D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF635BFF)
              : Colors.white10,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.white),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1020),
        elevation: 0,
        title: const Text('Video Downloader',style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DownloadsScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.download_rounded,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.settings_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              const Text('Download your media',style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),
              const Text('Paste a supported video URL and choose your preferred format.',style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF151B2D),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white10,
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _urlController,
                      keyboardType: TextInputType.url,
                      maxLines: 3,
                      minLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Paste video link here...',
                        hintStyle: const TextStyle(
                          color: Colors.white38,
                        ),
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.link_rounded,
                          color: Color(0xFF635BFF),
                        ),
                        suffixIcon: _urlController.text.isNotEmpty
                            ? IconButton(
                          onPressed: _clearUrl,
                          icon: const Icon(Icons.close_rounded,
                            color: Colors.white54,
                          ),
                        ) : null,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child:
                          OutlinedButton.icon(
                            onPressed: _pasteUrl,
                            icon: const Icon(Icons.content_paste_rounded,
                              size: 18,
                            ),
                            label: const Text('Paste'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                color: Colors.white24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child:
                          ElevatedButton.icon(
                            onPressed: _isLoading
                                ? null
                                : _getVideoInfo,
                            icon: _isLoading
                                ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                                : const Icon(Icons.arrow_forward_rounded,size: 18),
                            label: Text(_isLoading
                                  ? 'Checking...'
                                  : 'Continue',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF635BFF),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (_detectedPlatform != null) ...[
                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151B2D),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF635BFF).withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,color: Color(0xFF635BFF),),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('Detected: $_detectedPlatform', style: const TextStyle(
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 34),

              const Text('Supported Platforms', style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                height: 105,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _platforms.length,
                  separatorBuilder: (_, _) =>
                  const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return _buildPlatformCard(
                      _platforms[index],
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF151B2D),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded,color: Color(0xFF635BFF),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text('Only download content you have permission to download. Availability depends on the supported source and its permitted access.',
                        style: TextStyle(
                          color:
                          Colors.white54,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Center(
                child: Text('Video Downloader • Version 1.0.0',style: TextStyle(
                    color: Colors.white24,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}