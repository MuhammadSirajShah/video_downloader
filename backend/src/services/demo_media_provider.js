const MediaProvider = require('./media_provider');
const ProviderResult = require('./provider_result');

class DemoMediaProvider extends MediaProvider {
  async getVideoInfo(url, platform) {
    return new ProviderResult({
      success: true,
      platform: platform,
      sourceUrl: url,
      media: {
        title: `${platform} Demo Video`,
        thumbnail: null,
        duration: '00:30',
        formats: [
          {
            format: 'MP4',
            quality: '360p',
            url: null,
          },
          {
            format: 'MP4',
            quality: '480p',
            url: null,
          },
          {
            format: 'MP4',
            quality: '720p',
            url: null,
          },
          {
            format: 'MP4',
            quality: '1080p',
            url: null,
          },
          {
            format: 'MP3',
            quality: 'audio',
            url: null,
          },
        ],
      },
      message:
          'Demo provider is active. No real media download is performed.',
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
          'Demo provider does not provide real downloadable files.',
    }).toJson();
  }
}

module.exports = DemoMediaProvider;