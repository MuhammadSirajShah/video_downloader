class VideoModel {
  final bool success;
  final String platform;
  final String sourceUrl;
  final String? message;

  final String? title;
  final String? thumbnail;
  final String? duration;

  final List<VideoQuality> qualities;

  VideoModel({
    required this.success,
    required this.platform,
    required this.sourceUrl,
    this.message,
    this.title,
    this.thumbnail,
    this.duration,
    this.qualities = const [],
  });

  factory VideoModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final media = json['media'];

    String? title;
    String? thumbnail;
    String? duration;

    List<VideoQuality> qualities = [];

    // ==========================================
    // MEDIA DATA
    // ==========================================

    if (media is Map) {
      title = media['title']?.toString();

      thumbnail =
          media['thumbnail']?.toString();

      duration =
          media['duration']?.toString();

      // ========================================
      // FORMATS
      // ========================================

      final formats = media['formats'];

      if (formats is List) {
        qualities = formats
            .whereType<Map>()
            .map(
              (item) =>
              VideoQuality.fromJson(
                Map<String, dynamic>.from(
                  item,
                ),
              ),
        )
            .toList();
      }
    }

    return VideoModel(
      success: json['success'] == true,
      platform:
      json['platform']?.toString() ?? '',
      sourceUrl:
      json['sourceUrl']?.toString() ?? '',
      message:
      json['message']?.toString(),
      title: title,
      thumbnail: thumbnail,
      duration: duration,
      qualities: qualities,
    );
  }
}

// ==========================================
// VIDEO QUALITY
// ==========================================

class VideoQuality {
  final String format;
  final String quality;
  final String? url;

  VideoQuality({
    required this.format,
    required this.quality,
    this.url,
  });

  factory VideoQuality.fromJson(
      Map<String, dynamic> json,
      ) {
    return VideoQuality(
      format:
      json['format']?.toString() ?? '',
      quality:
      json['quality']?.toString() ?? '',
      url: json['url']?.toString(),
    );
  }
}