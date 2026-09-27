function detectPlatform(url) {
  if (typeof url !== 'string') {
    return null;
  }

  const value = url.trim();

  if (!value) {
    return null;
  }

  let parsedUrl;

  try {
    parsedUrl = new URL(value);
  } catch (error) {
    return null;
  }

  if (
    parsedUrl.protocol !== 'http:' &&
    parsedUrl.protocol !== 'https:'
  ) {
    return null;
  }

  const host =
    parsedUrl.hostname
      .toLowerCase()
      .replace(/^www\./, '');

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

function _isTikTok(host) {
  return (
    host === 'tiktok.com' ||
    host.endsWith('.tiktok.com')
  );
}

function _isInstagram(host) {
  return (
    host === 'instagram.com' ||
    host.endsWith('.instagram.com')
  );
}

function _isFacebook(host) {
  return (
    host === 'facebook.com' ||
    host.endsWith('.facebook.com') ||
    host === 'fb.watch'
  );
}

function _isYouTube(host) {
  return (
    host === 'youtube.com' ||
    host.endsWith('.youtube.com') ||
    host === 'youtube'
  );
}

function _isSnapchat(host) {
  return (
    host === 'snapchat.com' ||
    host.endsWith('.snapchat.com')
  );
}

function _isLike(host) {
  return (
    host === 'like.com' ||
    host.endsWith('.like.com') ||
    host === 'like.video' ||
    host.endsWith('.like.video')
  );
}

module.exports = {
  detectPlatform,
};