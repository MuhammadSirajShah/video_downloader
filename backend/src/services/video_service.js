const MediaProvider = require('./media_provider');

const mediaProvider = new MediaProvider();

async function getVideoInfo(url, platform) {
  try {
    return await mediaProvider.getVideoInfo(
      url,
      platform,
    );
  } catch (error) {
    console.error(
      'Media provider info error:',
      error.message,
    );

    return {
      success: false,
      platform: platform,
      sourceUrl: url,
      media: null,
      message:
        'Media provider is not connected yet.',
    };
  }
}

async function createDownloadJob({
  url,
  platform,
  format,
  quality,
}) {
  try {
    return await mediaProvider.createDownloadJob({
      url,
      platform,
      format,
      quality,
    });
  } catch (error) {
    console.error(
      'Media provider download error:',
      error.message,
    );

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
}

module.exports = {
  getVideoInfo,
  createDownloadJob,
};