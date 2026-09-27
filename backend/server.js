const express = require('express');
const cors = require('cors');
require('dotenv').config();

const {
  rateLimiter,
} = require('./src/middleware/rate_limiter');

const videoRoutes = require('./src/routes/video_routes');
const {
  validateJsonBody,
} = require('./src/middleware/request_validator');

const app = express();

const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(
  express.json({
    limit: '50kb',
  }),
);
app.use(validateJsonBody);

// Health check
app.get('/api/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Video Downloader API is running',
  });
});

// Video routes
app.use(
  '/api/video',
  rateLimiter,
  videoRoutes,
);

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found.',
  });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error('Server error:', err);

  if (res.headersSent) {
    return next(err);
  }

  res.status(500).json({
    success: false,
    message: 'Internal server error.',
  });
});

// Start server
app.listen(PORT, () => {
  console.log(
    `Server running on port ${PORT}`,
  );
});