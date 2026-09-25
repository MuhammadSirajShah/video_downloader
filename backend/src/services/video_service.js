async function getVideoInfo(url, platform) {
  // Actual media provider integration
  // will be connected here later.

  return {
    success: true,
    platform: platform,
    sourceUrl: url,
    media: null,
    message:
      'Media provider is not connected yet.',
  };
}

module.exports = {
  getVideoInfo,
};