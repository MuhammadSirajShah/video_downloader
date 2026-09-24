import 'package:flutter/material.dart';

class VideoOptionsScreen extends StatefulWidget {
  final String platform;
  final String videoUrl;

  const VideoOptionsScreen({
    super.key,
    required this.platform,
    required this.videoUrl,
  });

  @override
  State<VideoOptionsScreen> createState() =>
      _VideoOptionsScreenState();
}

class _VideoOptionsScreenState
    extends State<VideoOptionsScreen> {
  String _selectedFormat = 'MP4';
  String _selectedQuality = '720p';

  final List<String> _formats = [
    'MP4',
    'MP3',
  ];

  final List<String> _qualities = [
    '360p',
    '480p',
    '720p',
    '1080p',
  ];

  void _download() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Download system will be connected next.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Video Options',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0B1020),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // Video Preview
              Container(
                width: double.infinity,
                height: 210,
                decoration: BoxDecoration(
                  color: const Color(0xFF151B2D),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.video_library_rounded,
                      size: 70,
                      color: Color(0xFF635BFF),
                    ),

                    Positioned(
                      bottom: 14,
                      left: 14,
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.platform,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Video Title
              const Text(
                'Video',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'Selected ${widget.platform} video',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              // Format
              const Text(
                'Format',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: _formats.map((format) {
                  final selected =
                      _selectedFormat == format;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFormat = format;
                        });
                      },
                      child: Container(
                        margin:
                        const EdgeInsets.only(
                          right: 10,
                        ),
                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(
                            0xFF635BFF,
                          )
                              : const Color(
                            0xFF151B2D,
                          ),
                          borderRadius:
                          BorderRadius.circular(14),
                          border: Border.all(
                            color: selected
                                ? const Color(
                              0xFF635BFF,
                            )
                                : Colors.white10,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              format == 'MP4'
                                  ? Icons
                                  .video_file_rounded
                                  : Icons
                                  .audio_file_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(height: 7),
                            Text(
                              format,
                              style: const TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // Quality
              const Text(
                'Video Quality',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                _qualities.map((quality) {
                  final selected =
                      _selectedQuality == quality;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedQuality =
                            quality;
                      });
                    },
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF635BFF)
                            : const Color(0xFF151B2D),
                        borderRadius:
                        BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? const Color(
                            0xFF635BFF,
                          )
                              : Colors.white10,
                        ),
                      ),
                      child: Text(
                        quality,
                        style: const TextStyle(
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // Download
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _download,
                  icon: const Icon(
                    Icons.download_rounded,
                  ),
                  label: Text(
                    'Download $_selectedFormat',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF635BFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Information
              const Text(
                'Available formats and qualities will depend on the supported source and its permitted access.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}