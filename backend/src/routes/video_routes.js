const express = require('express');

const {
  getVideoInfo,
} = require('../controllers/video_controller');

const router = express.Router();

router.post('/info', getVideoInfo);

module.exports = router;