class MediaProvider {
  async getVideoInfo(url, platform) {
    throw new Error(
      'Media provider getVideoInfo() is not implemented.',
    );
  }

  async createDownloadJob({
    url,
    platform,
    format,
    quality,
  }) {
    throw new Error(
      'Media provider createDownloadJob() is not implemented.',
    );
  }
}

module.exports = MediaProvider;