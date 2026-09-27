const MAX_URL_LENGTH = 2048;

function validateJsonBody(req, res, next) {
  if (req.method !== 'POST') {
    return next();
  }

  if (
    !req.body ||
    typeof req.body !== 'object' ||
    Array.isArray(req.body)
  ) {
    return res.status(400).json({
      success: false,
      message: 'Invalid request body.',
    });
  }

  const url = req.body.url;

  if (url !== undefined) {
    if (typeof url !== 'string') {
      return res.status(400).json({
        success: false,
        message: 'URL must be a string.',
      });
    }

    const cleanUrl = url.trim();

    if (!cleanUrl) {
      return res.status(400).json({
        success: false,
        message: 'URL cannot be empty.',
      });
    }

    if (cleanUrl.length > MAX_URL_LENGTH) {
      return res.status(400).json({
        success: false,
        message: 'URL is too long.',
      });
    }

    req.body.url = cleanUrl;
  }

  return next();
}

module.exports = {
  validateJsonBody,
};