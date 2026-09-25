const {
  getMediaProvider,
} = require('./provider_factory');

async function getVideoInfo(url, platform) {
  try {
    const provider =
      getMediaProvider(platform);

    return await provider.getVideoInfo(
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
        'Unable to process this media request.',
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
    const provider =
      getMediaProvider(platform);

    return await provider.createDownloadJob({
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
        'Unable to create the download request.',
    };
  }
}

module.exports = {
  getVideoInfo,
  createDownloadJob,
};