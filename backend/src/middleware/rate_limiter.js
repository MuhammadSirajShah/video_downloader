const requestCounts = new Map();

const WINDOW_MS = 60 * 1000;
const MAX_REQUESTS = 30;

function getClientKey(req) {
  const forwardedFor = req.headers['x-forwarded-for'];

  if (
    typeof forwardedFor === 'string' &&
    forwardedFor.trim().length > 0
  ) {
    return forwardedFor
      .split(',')[0]
      .trim();
  }

  return req.ip || 'unknown';
}

function rateLimiter(req, res, next) {
  const now = Date.now();
  const key = getClientKey(req);

  const current = requestCounts.get(key);

  if (!current ||
      now - current.startTime >= WINDOW_MS) {
    requestCounts.set(key, {
      startTime: now,
      count: 1,
    });

    return next();
  }

  if (current.count >= MAX_REQUESTS) {
    const retryAfter =
        Math.ceil(
          (WINDOW_MS -
              (now - current.startTime)) /
              1000,
        );

    res.set(
      'Retry-After',
      retryAfter.toString(),
    );

    return res.status(429).json({
      success: false,
      message:
          'Too many requests. Please try again later.',
    });
  }

  current.count += 1;

  return next();
}

function cleanupRateLimitStore() {
  const now = Date.now();

  for (const [
    key,
    value,
  ] of requestCounts.entries()) {
    if (
      now - value.startTime >=
      WINDOW_MS
    ) {
      requestCounts.delete(key);
    }
  }
}

setInterval(
  cleanupRateLimitStore,
  WINDOW_MS,
).unref();

module.exports = {
  rateLimiter,
};