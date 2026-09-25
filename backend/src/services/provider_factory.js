const MediaProvider = require('./media_provider');

function getMediaProvider(platform) {
  const providerName =
    (process.env.MEDIA_PROVIDER || 'none')
      .toLowerCase()
      .trim();

  switch (providerName) {
    case 'none':
      return new MediaProvider();

    default:
      console.warn(
        `Unknown MEDIA_PROVIDER: ${providerName}`,
      );

      return new MediaProvider();
  }
}

module.exports = {
  getMediaProvider,
};