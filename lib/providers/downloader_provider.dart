import 'package:flutter/foundation.dart';

class DownloadItem {
  final String id;
  final String platform;
  final String url;
  final String format;
  final String? quality;
  final DateTime createdAt;
  final String status;

  DownloadItem({
    required this.id,
    required this.platform,
    required this.url,
    required this.format,
    required this.quality,
    required this.createdAt,
    required this.status,
  });
}

class DownloaderProvider extends ChangeNotifier {
  final List<DownloadItem> _downloads = [];

  List<DownloadItem> get downloads =>
      List.unmodifiable(_downloads);

  void addDownload({
    required String id,
    required String platform,
    required String url,
    required String format,
    String? quality,
  }) {
    _downloads.insert(
      0,
      DownloadItem(
        id: id,
        platform: platform,
        url: url,
        format: format,
        quality: quality,
        createdAt: DateTime.now(),
        status: 'Preparing',
      ),
    );

    notifyListeners();
  }

  void updateStatus(
      String id,
      String status,
      ) {
    final index = _downloads.indexWhere(
          (item) => item.id == id,
    );

    if (index == -1) return;

    final oldItem = _downloads[index];

    _downloads[index] = DownloadItem(
      id: oldItem.id,
      platform: oldItem.platform,
      url: oldItem.url,
      format: oldItem.format,
      quality: oldItem.quality,
      createdAt: oldItem.createdAt,
      status: status,
    );

    notifyListeners();
  }

  void removeDownload(String id) {
    _downloads.removeWhere(
          (item) => item.id == id,
    );

    notifyListeners();
  }

  void clearDownloads() {
    _downloads.clear();
    notifyListeners();
  }
}