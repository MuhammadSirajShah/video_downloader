const express = require('express');
const cors = require('cors');
require('dotenv').config();

const videoRoutes = require('./src/routes/video_routes');

const app = express();

const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/api/health', (req, res) => {
  res.json({
    success: true,
    message: 'Video Downloader API is running',
  });
});

app.use('/api/video', videoRoutes);

app.listen(PORT, () => {
  console.log(
    `Server running on port ${PORT}`
  );
});