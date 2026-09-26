import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/video_model.dart';
import '../../providers/downloader_provider.dart';
import '../../services/api_service.dart';
import '../../services/downloader_service.dart';

class VideoOptionsScreen extends StatefulWidget {
  final String platform;
  final String videoUrl;
  final VideoModel videoInfo;

  const VideoOptionsScreen({super.key,
    required this.platform,
    required this.videoUrl,
    required this.videoInfo,
  });

  @override
  State<VideoOptionsScreen> createState() => _VideoOptionsScreenState();
}

class _VideoOptionsScreenState extends State<VideoOptionsScreen> {
  final ApiService _apiService = ApiService();

  final DownloaderService _downloaderService = DownloaderService();

  bool _isDownloading = false;
  String _selectedFormat = 'MP4';
  String _selectedQuality = '720p';
  final List<String> _formats = [
    'MP4',
    'MP3',
  ];
  final List<String> _defaultQualities = [
    '360p',
    '480p',
    '720p',
    '1080p',
  ];

  // ==========================================
  // VIDEO TITLE
  // ==========================================

  String get _videoTitle {
    if (widget.videoInfo.title != null &&
        widget.videoInfo.title!.trim().isNotEmpty) {
      return widget.videoInfo.title!;
    }

    return '${widget.platform} Video';
  }

  // ==========================================
  // VIDEO DURATION
  // ==========================================

  String? get _videoDuration {
    if (widget.videoInfo.duration != null &&
        widget.videoInfo.duration!.trim().isNotEmpty) {
      return widget.videoInfo.duration!;
    }

    return null;
  }

  // ==========================================
  // MEDIA DATA
  // ==========================================

  // Map<String, dynamic>? _getMedia() {
  //   final formats =
  //       widget.videoInfo.qualities;
  //
  //   if (formats.isEmpty) {
  //     return null;
  //   }
  //
  //   return {
  //     'title': _videoTitleFallback,
  //   };
  // }

  String get _videoTitleFallback {
    return '${widget.platform} Video';
  }

  // ==========================================
  // AVAILABLE QUALITIES
  // ==========================================

  List<String> get _availableQualities {
    if (widget.videoInfo.qualities.isEmpty) {
      return _defaultQualities;
    }

    final qualities = widget.videoInfo.qualities
        .where(
          (item) =>
      item.format.toUpperCase() == 'MP4',
    )
        .map((item) => item.quality)
        .where(
          (quality) => quality.isNotEmpty,
    )
        .toSet()
        .toList();

    if (qualities.isEmpty) {
      return _defaultQualities;
    }

    return qualities;
  }

  // ==========================================
  // DOWNLOAD
  // ==========================================

  Future<void> _download() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    final result = await _apiService.createDownloadJob(
      url: widget.videoUrl,
      format: _selectedFormat,
      quality: _selectedFormat == 'MP4'
          ? _selectedQuality
          : null,
    );
    if (!mounted) return;
    if (result['success'] != true) {
      setState(() {
        _isDownloading = false;
      });

      _showMessage(
        result['message'] ??
            'Download could not be started.',
      );

      return;
    }

    final downloadUrl = result['downloadUrl'];

    if (downloadUrl == null || downloadUrl.toString().isEmpty) {
      setState(() {
        _isDownloading = false;
      });
      _showMessage(
        'No downloadable file was returned by the server.',
      );

      return;
    }

    final id = const Uuid().v4();
    final provider = context.read<DownloaderProvider>();
    await provider.addDownload(
      id: id,
      platform: widget.platform,
      url: widget.videoUrl,
      format: _selectedFormat,
      quality: _selectedFormat == 'MP4'
          ? _selectedQuality
          : null,
    );

    await provider.updateStatus(
      id, 'Downloading',
    );

    try {
      final extension = _selectedFormat.toLowerCase();

      final fileName = '${widget.platform}_${DateTime.now().millisecondsSinceEpoch}.$extension';

      final filePath = await _downloaderService.downloadFile(
        downloadUrl: downloadUrl.toString(),
        fileName: fileName,
        onProgress: (progress) {
          provider.updateProgress(
            id,
            progress,
          );
        },
      );

      await provider.updateFilePath(
        id, filePath,
      );

      await provider.updateProgress(
        id, 1.0,
      );

      await provider.updateStatus(
        id, 'Completed',
      );

      if (!mounted) return;

      setState(() {
        _isDownloading = false;
      });

      _showMessage(
        'Download completed successfully.',
      );
    } catch (e) {
      await provider.updateStatus(
        id, 'Failed',
      );

      if (!mounted) return;

      setState(() {
        _isDownloading = false;
      });

      _showMessage(
        'Download failed. Please try again.',
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
          behavior:
          SnackBarBehavior.floating,
        ),
      );
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    final qualities = _availableQualities;

    if (qualities.isNotEmpty && !qualities.contains(
          _selectedQuality,
        )) {
      _selectedQuality = qualities.first;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      appBar: AppBar(
        title: const Text(
          'Video Options', style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0B1020),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ==================================
              // VIDEO PREVIEW
              // ==================================

              Container(
                width: double.infinity,
                height: 210,
                decoration: BoxDecoration(
                  color: const Color(0xFF151B2D),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white10,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (widget.videoInfo.thumbnail != null &&
                        widget.videoInfo.thumbnail!.trim().isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: widget.videoInfo.thumbnail!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF635BFF),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return const Center(
                            child: Icon(
                              Icons.video_library_rounded,
                              size: 70,
                              color: Color(0xFF635BFF),
                            ),
                          );
                        },
                      )
                    else
                      const Center(
                        child: Icon(
                          Icons.video_library_rounded,
                          size: 70,
                          color: Color(0xFF635BFF),
                        ),
                      ),

                    // Dark overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.65),
                          ],
                        ),
                      ),
                    ),

                    // Platform
                    Positioned(
                      bottom: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.platform,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // Duration
                    if (_videoDuration != null)
                      Positioned(
                        bottom: 14,
                        right: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            _videoDuration!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==================================
              // VIDEO INFORMATION
              // ==================================

              const Text(
                'Video',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                _videoTitle,
                maxLines: 2,
                overflow:
                TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                widget.videoUrl,
                maxLines: 2,
                overflow:
                TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),

              if (_videoDuration != null) ...[
                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons
                          .access_time_rounded,
                      size: 16,
                      color:
                      Colors.white54,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _videoDuration!,
                      style:
                      const TextStyle(
                        color:
                        Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 28),

              // ==================================
              // FORMAT
              // ==================================

              const Text(
                'Format',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children:
                _formats.map((format) {
                  final selected =
                      _selectedFormat ==
                          format;

                  return Expanded(
                    child:
                    GestureDetector(
                      onTap: () {
                        if (_isDownloading) {
                          return;
                        }

                        setState(() {
                          _selectedFormat =
                              format;

                          if (format ==
                              'MP4' &&
                              qualities
                                  .isNotEmpty &&
                              !qualities
                                  .contains(
                                _selectedQuality,
                              )) {
                            _selectedQuality =
                                qualities.first;
                          }
                        });
                      },
                      child:
                      Container(
                        margin:
                        const EdgeInsets
                            .only(
                          right: 10,
                        ),
                        padding:
                        const EdgeInsets
                            .symmetric(
                          vertical: 16,
                        ),
                        decoration:
                        BoxDecoration(
                          color: selected
                              ? const Color(
                            0xFF635BFF,
                          )
                              : const Color(
                            0xFF151B2D,
                          ),
                          borderRadius:
                          BorderRadius
                              .circular(
                            14,
                          ),
                          border:
                          Border.all(
                            color: selected
                                ? const Color(
                              0xFF635BFF,
                            )
                                : Colors.white10,
                          ),
                        ),
                        child:
                        Column(
                          children: [
                            Icon(
                              format ==
                                  'MP4'
                                  ? Icons
                                  .video_file_rounded
                                  : Icons
                                  .audio_file_rounded,
                              color:
                              Colors.white,
                              size: 28,
                            ),

                            const SizedBox(
                              height: 7,
                            ),

                            Text(
                              format,
                              style:
                              const TextStyle(
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // ==================================
              // QUALITY
              // ==================================

              if (_selectedFormat ==
                  'MP4') ...[
                const SizedBox(height: 28),

                const Text(
                  'Video Quality',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                  qualities.map(
                        (quality) {
                      final selected =
                          _selectedQuality ==
                              quality;

                      return GestureDetector(
                        onTap: () {
                          if (_isDownloading) {
                            return;
                          }

                          setState(() {
                            _selectedQuality =
                                quality;
                          });
                        },
                        child:
                        Container(
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration:
                          BoxDecoration(
                            color: selected
                                ? const Color(
                              0xFF635BFF,
                            )
                                : const Color(
                              0xFF151B2D,
                            ),
                            borderRadius:
                            BorderRadius
                                .circular(
                              12,
                            ),
                            border:
                            Border.all(
                              color: selected
                                  ? const Color(
                                0xFF635BFF,
                              )
                                  : Colors.white10,
                            ),
                          ),
                          child:
                          Text(
                            quality,
                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight
                                  .w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],

              const SizedBox(height: 30),

              // ==================================
              // DOWNLOAD BUTTON
              // ==================================

              SizedBox(
                width: double.infinity,
                height: 56,
                child:
                ElevatedButton.icon(
                  onPressed:
                  _isDownloading
                      ? null
                      : _download,
                  icon: _isDownloading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color:
                      Colors.white,
                    ),
                  )
                      : const Icon(Icons.download_rounded,),
                  label: Text(
                    _isDownloading
                        ? 'Downloading...'
                        : _selectedFormat ==
                        'MP4'
                        ? 'Download MP4 ($_selectedQuality)'
                        : 'Download MP3',
                    style:
                    const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(
                      0xFF635BFF,
                    ),
                    foregroundColor:
                    Colors.white,
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

              const SizedBox(height: 15),

              const Text(
                'Available formats and qualities depend on the supported source and its permitted access.',
                textAlign:
                TextAlign.center,
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