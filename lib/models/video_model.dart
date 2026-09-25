class VideoModel {
  final bool success;
  final String platform;
  final String sourceUrl;
  final String? message;
  final List<VideoQuality> qualities;

  VideoModel({
    required this.success,
    required this.platform,
    required this.sourceUrl,
    this.message,
    this.qualities = const [],
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    final media = json['media'];

    List<VideoQuality> qualities = [];

    if (media is Map<String, dynamic>) {
      final formats = media['formats'];

      if (formats is List) {
        qualities = formats
            .whereType<Map>()
            .map(
              (item) => VideoQuality.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
            .toList();
      }
    }

    return VideoModel(
      success: json['success'] == true,
      platform: json['platform'] ?? '',
      sourceUrl: json['sourceUrl'] ?? '',
      message: json['message'],
      qualities: qualities,
    );
  }
}

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
      format: json['format'] ?? '',
      quality: json['quality'] ?? '',
      url: json['url'],
    );
  }
}