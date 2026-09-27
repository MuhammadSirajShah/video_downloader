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
        message: 'Video URL is required.',
      });
    }

    const platform = detectPlatform(url);

    if (!platform) {
      return res.status(400).json({
        success: false,
        message:
          'Unsupported platform or invalid URL.',
      });
    }

    const result =
      await getVideoInfoFromService(
        url,
        platform,
      );

    return res.status(200).json(result);
  } catch (error) {
    console.error(
      'Video info controller error:',
      error,
    );

    return res.status(500).json({
      success: false,
      message: 'Internal server error.',
    });
  }
}

async function downloadVideo(req, res) {
  try {
    const url = getCleanUrl(req.body?.url);

    if (!url) {
      return res.status(400).json({
        success: false,
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
          message:
            'Invalid video quality.',
        });
      }
    }

    const platform = detectPlatform(url);

    if (!platform) {
      return res.status(400).json({
        success: false,
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

    return res.status(200).json(result);
  } catch (error) {
    console.error(
      'Video download controller error:',
      error,
    );

    return res.status(500).json({
      success: false,
      message: 'Internal server error.',
    });
  }
}

module.exports = {
  getVideoInfo,
  downloadVideo,
};