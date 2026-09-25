const {
  detectPlatform,
} = require('../utils/url_detector');

const {
  getVideoInfo: getVideoInfoFromService,
  createDownloadJob,
} = require('../services/video_service');

async function getVideoInfo(req, res) {
  try {
    const { url } = req.body;

    if (!url || typeof url !== 'string') {
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

    if (!format || !['MP4', 'MP3'].includes(format)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid format.',
      });
    }

    if (format === 'MP4' && !quality) {
      return res.status(400).json({
        success: false,
        message: 'Video quality is required.',
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

    const result = await createDownloadJob({
      url,
      platform,
      format,
      quality: quality || null,
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