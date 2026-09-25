class ProviderResult {
  constructor({
    success,
    platform,
    sourceUrl,
    media = null,
    format = null,
    quality = null,
    downloadUrl = null,
    message = null,
  }) {
    this.success = success;
    this.platform = platform;
    this.sourceUrl = sourceUrl;
    this.media = media;
    this.format = format;
    this.quality = quality;
    this.downloadUrl = downloadUrl;
    this.message = message;
  }

  toJson() {
    return {
      success: this.success,
      platform: this.platform,
      sourceUrl: this.sourceUrl,
      media: this.media,
      format: this.format,
      quality: this.quality,
      downloadUrl: this.downloadUrl,
      message: this.message,
    };
  }
}

module.exports = ProviderResult;