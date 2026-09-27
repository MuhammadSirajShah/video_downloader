function validateJsonBody(req, res, next) {
  if (
    req.method === 'POST' &&
    (!req.body || typeof req.body !== 'object')
  ) {
    return res.status(400).json({
      success: false,
      message: 'Invalid request body.',
    });
  }

  next();
}

module.exports = {
  validateJsonBody,
};