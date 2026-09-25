import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'platform': platform,
      'url': url,
      'format': format,
      'quality': quality,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory DownloadItem.fromJson(
      Map<String, dynamic> json,
      ) {
    return DownloadItem(
      id: json['id'] ?? '',
      platform: json['platform'] ?? '',
      url: json['url'] ?? '',
      format: json['format'] ?? '',
      quality: json['quality'],
      createdAt: DateTime.tryParse(
        json['createdAt'] ?? '',
      ) ??
          DateTime.now(),
      status: json['status'] ?? 'Preparing',
    );
  }
}

class DownloaderProvider extends ChangeNotifier {
  static const String _storageKey =
      'download_items';

  final List<DownloadItem> _downloads = [];

  List<DownloadItem> get downloads =>
      List.unmodifiable(_downloads);

  Future<void> loadDownloads() async {
    final prefs =
    await SharedPreferences.getInstance();

    final savedData =
    prefs.getString(_storageKey);

    if (savedData == null || savedData.isEmpty) {
      return;
    }

    try {
      final List<dynamic> decoded =
      jsonDecode(savedData);

      _downloads.clear();

      _downloads.addAll(
        decoded
            .whereType<Map>()
            .map(
              (item) => DownloadItem.fromJson(
            Map<String, dynamic>.from(item),
          ),
        ),
      );

      notifyListeners();
    } catch (e) {
      debugPrint(
        'Failed to load downloads: $e',
      );
    }
  }

  Future<void> _saveDownloads() async {
    final prefs =
    await SharedPreferences.getInstance();

    final data = _downloads
        .map((item) => item.toJson())
        .toList();

    await prefs.setString(
      _storageKey,
      jsonEncode(data),
    );
  }

  Future<void> addDownload({
    required String id,
    required String platform,
    required String url,
    required String format,
    String? quality,
  }) async {
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

    await _saveDownloads();
  }

  Future<void> updateStatus(
      String id,
      String status,
      ) async {
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

    await _saveDownloads();
  }

  Future<void> removeDownload(String id) async {
    _downloads.removeWhere(
          (item) => item.id == id,
    );

    notifyListeners();

    await _saveDownloads();
  }

  Future<void> clearDownloads() async {
    _downloads.clear();

    notifyListeners();

    await _saveDownloads();
  }
}