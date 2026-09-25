const express = require('express');

const {
  getVideoInfo,
  downloadVideo,
} = require('../controllers/video_controller');

const router = express.Router();

router.post('/info', getVideoInfo);

router.post('/download', downloadVideo);

module.exports = router;