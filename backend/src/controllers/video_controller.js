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

async function getVideoInfo(req, res) {
  try {
    const { url } = req.body;

    if (!url || typeof url !== 'string') {
      return res.status(400).json({
        success: false,
        message: 'Video URL is required.',
      });
    }

    const cleanUrl = url.trim();

    if (!cleanUrl) {
      return res.status(400).json({
        success: false,
        message: 'Video URL cannot be empty.',
      });
    }

    const platform = detectPlatform(cleanUrl);

    if (!platform) {
      return res.status(400).json({
        success: false,
        message:
          'Unsupported platform or invalid URL.',
      });
    }

    const result =
      await getVideoInfoFromService(
        cleanUrl,
        platform,
      );

    return res.json(result);
  } catch (error) {
    console.error(error);

    return res.status(500).json({
      success: false,
      message: 'Internal server error.',
    });
  }
}

async function downloadVideo(req, res) {
  try {
    const {
      url,
      format,
      quality,
    } = req.body;

    if (!url || typeof url !== 'string') {
      return res.status(400).json({
        success: false,
        message: 'Video URL is required.',
      });
    }

    const cleanUrl = url.trim();

    if (!cleanUrl) {
      return res.status(400).json({
        success: false,
        message: 'Video URL cannot be empty.',
      });
    }

    const normalizedFormat =
      typeof format === 'string'
        ? format.trim().toUpperCase()
        : '';

    if (
      !ALLOWED_FORMATS.includes(
        normalizedFormat,
      )
    ) {
      return res.status(400).json({
        success: false,
        message:
          'Invalid format. Use MP4 or MP3.',
      });
    }

    let normalizedQuality = null;

    if (normalizedFormat === 'MP4') {
      normalizedQuality =
        typeof quality === 'string'
          ? quality.trim().toLowerCase()
          : '';

      if (
        !ALLOWED_QUALITIES.includes(
          normalizedQuality,
        )
      ) {
        return res.status(400).json({
          success: false,
          message:
            'Invalid video quality.',
        });
      }
    }

    const platform =
      detectPlatform(cleanUrl);

    if (!platform) {
      return res.status(400).json({
        success: false,
        message:
          'Unsupported platform or invalid URL.',
      });
    }

    const result =
      await createDownloadJob({
        url: cleanUrl,
        platform,
        format: normalizedFormat,
        quality: normalizedQuality,
      });

    return res.json(result);
  } catch (error) {
    console.error(error);

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