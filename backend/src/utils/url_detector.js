function detectPlatform(url) {
  const value = url.toLowerCase().trim();

  if (value.includes('tiktok.com')) {
    return 'TikTok';
  }

  if (
    value.includes('instagram.com')
  ) {
    return 'Instagram';
  }

  if (
    value.includes('facebook.com') ||
    value.includes('fb.watch')
  ) {
    return 'Facebook';
  }

  if (
    value.includes('youtube.com') ||
    value.includes('youtube')
  ) {
    return 'YouTube';
  }

  if (value.includes('snapchat.com')) {
    return 'Snapchat';
  }

  if (
    value.includes('like.com') ||
    value.includes('like.video')
  ) {
    return 'Like';
  }

  return null;
}

module.exports = {
  detectPlatform,
};