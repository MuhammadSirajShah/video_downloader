const {
  detectPlatform,
} = require('../utils/url_detector');

const {
  getVideoInfo: getVideoInfoFromService,
  createDownloadJob,
} = require('../services/video_service');

const ALLOWED_FORMATS = [
  'MP4',
  'MP3',
];

const ALLOWED_QUALITIES = [
  '360p',
  '480p',
  '720p',
  '1080p',
];

function getCleanUrl(value) {
  if (typeof value !== 'string') {
    return null;
  }

  const url = value.trim();

  if (!url) {
    return null;
  }

  return url;
}

async function getVideoInfo(req, res) {
  try {
    const url = getCleanUrl(req.body?.url);

    if (!url) {
      return res.status(400).json({
        success: false,
        platform: null,
        sourceUrl: null,
        media: null,
        message: 'Video URL is required.',
      });
    }

    const platform = detectPlatform(url);

    if (!platform) {
      return res.status(400).json({
        success: false,
        platform: null,
        sourceUrl: url,
        media: null,
        message:
          'Unsupported platform or invalid URL.',
      });
    }

    const result =
      await getVideoInfoFromService(
        url,
        platform,
      );

    if (!result || typeof result !== 'object') {
      return res.status(502).json({
        success: false,
        platform,
        sourceUrl: url,
        media: null,
        message:
          'Invalid response from media provider.',
      });
    }

    return res.status(
      result.success ? 200 : 502,
    ).json(result);
  } catch (error) {
    console.error(
      'Video info controller error:',
      error,
    );

    return res.status(500).json({
      success: false,
      platform: null,
      sourceUrl: null,
      media: null,
      message:
        'Unable to process the video request.',
    });
  }
}

async function downloadVideo(req, res) {
  try {
    const url = getCleanUrl(req.body?.url);

    if (!url) {
      return res.status(400).json({
        success: false,
        platform: null,
        sourceUrl: null,
        format: null,
        quality: null,
        downloadUrl: null,
        message: 'Video URL is required.',
      });
    }

    const format =
      typeof req.body?.format === 'string'
        ? req.body.format
            .trim()
            .toUpperCase()
        : '';

    if (!ALLOWED_FORMATS.includes(format)) {
      return res.status(400).json({
        success: false,
        platform: null,
        sourceUrl: url,
        format: format || null,
        quality: null,
        downloadUrl: null,
        message:
          'Invalid format. Use MP4 or MP3.',
      });
    }

    let quality = null;

    if (format === 'MP4') {
      quality =
        typeof req.body?.quality === 'string'
          ? req.body.quality
              .trim()
              .toLowerCase()
          : '';

      if (
        !ALLOWED_QUALITIES.includes(
          quality,
        )
      ) {
        return res.status(400).json({
          success: false,
          platform: null,
          sourceUrl: url,
          format,
          quality: quality || null,
          downloadUrl: null,
          message:
            'Invalid video quality.',
        });
      }
    }

    const platform = detectPlatform(url);

    if (!platform) {
      return res.status(400).json({
        success: false,
        platform: null,
        sourceUrl: url,
        format,
        quality,
        downloadUrl: null,
        message:
          'Unsupported platform or invalid URL.',
      });
    }

    const result =
      await createDownloadJob({
        url,
        platform,
        format,
        quality,
      });

    if (!result ||
        typeof result !== 'object') {
      return res.status(502).json({
        success: false,
        platform,
        sourceUrl: url,
        format,
        quality,
        downloadUrl: null,
        message:
          'Invalid response from media provider.',
      });
    }

    return res.status(
      result.success ? 200 : 502,
    ).json(result);
  } catch (error) {
    console.error(
      'Video download controller error:',
      error,
    );

    return res.status(500).json({
      success: false,
      platform: null,
      sourceUrl: null,
      format: null,
      quality: null,
      downloadUrl: null,
      message:
        'Unable to create the download request.',
    });
  }
}

module.exports = {
  getVideoInfo,
  downloadVideo,
};