class UrlDetector {
  static String? detectPlatform(String url) {
    final value = url.toLowerCase().trim();

    if (value.contains('tiktok.com')) {
      return 'TikTok';
    }

    if (value.contains('instagram.com')) {
      return 'Instagram';
    }

    if (value.contains('facebook.com') ||
        value.contains('fb.watch')) {
      return 'Facebook';
    }

    if (value.contains('youtube.com') ||
        value.contains('youtube')) {
      return 'YouTube';
    }

    if (value.contains('snapchat.com')) {
      return 'Snapchat';
    }

    if (value.contains('like.video') ||
        value.contains('like.com')) {
      return 'Like';
    }

    return null;
  }
}