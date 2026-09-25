const ProviderResult = require('./provider_result');

class MediaProvider {
  async getVideoInfo(url, platform) {
    return new ProviderResult({
      success: false,
      platform: platform,
      sourceUrl: url,
      message:
        'No media provider is configured.',
    }).toJson();
  }

  async createDownloadJob({
    url,
    platform,
    format,
    quality,
  }) {
    return new ProviderResult({
      success: false,
      platform: platform,
      sourceUrl: url,
      format: format,
      quality: quality,
      downloadUrl: null,
      message:
        'No media provider is configured.',
    }).toJson();
  }
}

module.exports = MediaProvider;