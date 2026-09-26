const ProviderResult = require('./provider_result');

class MediaProvider {
  /**
   * Get metadata for a permitted media source.
   */
  async getVideoInfo(url, platform) {
    return new ProviderResult({
      success: false,
      platform: platform,
      sourceUrl: url,
      message:
        'No media provider is configured for this source.',
    }).toJson();
  }

  /**
   * Create a download job for a permitted media source.
   */
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
        'No media provider is configured for this source.',
    }).toJson();
  }
}

module.exports = MediaProvider;