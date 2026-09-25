async function getVideoInfo(url, platform) {
  return {
    success: true,
    platform: platform,
    sourceUrl: url,
    media: null,
    message:
      'Media provider is not connected yet.',
  };
}

async function createDownloadJob({
  url,
  platform,
  format,
  quality,
}) {
  // Actual permitted media provider
  // will be connected here later.

  return {
    success: false,
    platform: platform,
    sourceUrl: url,
    format: format,
    quality: quality,
    downloadUrl: null,
    message:
      'Download provider is not connected yet.',
  };
}

module.exports = {
  getVideoInfo,
  createDownloadJob,
};