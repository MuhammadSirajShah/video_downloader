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
    String? title;
    String? thumbnail;
    String? duration;

    final List<VideoQuality> qualities = [];

    final media = json['media'];

    if (media is Map) {
      final mediaMap = Map<String, dynamic>.from(
        media,
      );

      final titleValue = mediaMap['title'];

      if (titleValue != null) {
        final value = titleValue.toString().trim();

        if (value.isNotEmpty) {
          title = value;
        }
      }

      final thumbnailValue =
      mediaMap['thumbnail'];

      if (thumbnailValue != null) {
        final value =
        thumbnailValue.toString().trim();

        if (value.isNotEmpty) {
          thumbnail = value;
        }
      }

      final durationValue =
      mediaMap['duration'];

      if (durationValue != null) {
        final value =
        durationValue.toString().trim();

        if (value.isNotEmpty) {
          duration = value;
        }
      }

      final formats = mediaMap['formats'];

      if (formats is List) {
        for (final item in formats) {
          if (item is Map) {
            qualities.add(
              VideoQuality.fromJson(
                Map<String, dynamic>.from(
                  item,
                ),
              ),
            );
          }
        }
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