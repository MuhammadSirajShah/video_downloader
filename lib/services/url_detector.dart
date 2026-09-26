class UrlDetector {
  static String? detectPlatform(String url) {
    final value = url.trim();

    if (value.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(value);

    if (uri == null ||
        (uri.scheme != 'http' &&
            uri.scheme != 'https') ||
        uri.host.isEmpty) {
      return null;
    }

    final host = uri.host.toLowerCase();

    if (_isTikTok(host)) {
      return 'TikTok';
    }

    if (_isInstagram(host)) {
      return 'Instagram';
    }

    if (_isFacebook(host)) {
      return 'Facebook';
    }

    if (_isYouTube(host)) {
      return 'YouTube';
    }

    if (_isSnapchat(host)) {
      return 'Snapchat';
    }

    if (_isLike(host)) {
      return 'Like';
    }

    return null;
  }

  static bool _isTikTok(String host) {
    return host == 'tiktok.com' ||
        host.endsWith('.tiktok.com');
  }

  static bool _isInstagram(String host) {
    return host == 'instagram.com' ||
        host.endsWith('.instagram.com');
  }

  static bool _isFacebook(String host) {
    return host == 'facebook.com' ||
        host.endsWith('.facebook.com') ||
        host == 'fb.watch';
  }

  static bool _isYouTube(String host) {
    return host == 'youtube.com' ||
        host.endsWith('.youtube.com') ||
        host == 'youtube';
  }

  static bool _isSnapchat(String host) {
    return host == 'snapchat.com' ||
        host.endsWith('.snapchat.com');
  }

  static bool _isLike(String host) {
    return host == 'like.com' ||
        host.endsWith('.like.com') ||
        host == 'like.video' ||
        host.endsWith('.like.video');
  }
}