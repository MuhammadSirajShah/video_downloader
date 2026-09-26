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
  final String? filePath;
  final double progress;

  DownloadItem({
    required this.id,
    required this.platform,
    required this.url,
    required this.format,
    required this.quality,
    required this.createdAt,
    required this.status,
    this.filePath,
    this.progress = 0.0,
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
      'filePath': filePath,
      'progress': progress,
    };
  }

  factory DownloadItem.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawProgress = json['progress'];

    double progress = 0.0;

    if (rawProgress is num) {
      progress = rawProgress.toDouble();
    } else if (rawProgress is String) {
      progress = double.tryParse(rawProgress) ?? 0.0;
    }

    return DownloadItem(
      id: json['id']?.toString() ?? '',
      platform: json['platform']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      format: json['format']?.toString() ?? '',
      quality: json['quality']?.toString(),
      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ) ??
          DateTime.now(),
      status: json['status']?.toString() ?? 'Preparing',
      filePath: json['filePath']?.toString(),
      progress: progress.clamp(0.0, 1.0),
    );
  }
}

class DownloaderProvider extends ChangeNotifier {
  static const String _storageKey = 'download_items';

  final List<DownloadItem> _downloads = [];

  List<DownloadItem> get downloads =>
      List.unmodifiable(_downloads);

  // ==========================================
  // LOAD DOWNLOADS
  // ==========================================

  Future<void> loadDownloads() async {
    final prefs =
    await SharedPreferences.getInstance();

    final savedData =
    prefs.getString(_storageKey);

    if (savedData == null || savedData.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(savedData);

      if (decoded is! List) {
        debugPrint(
          'Saved downloads data is not a list.',
        );
        return;
      }

      final loadedDownloads = <DownloadItem>[];

      for (final item in decoded) {
        if (item is Map) {
          loadedDownloads.add(
            DownloadItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }

      _downloads
        ..clear()
        ..addAll(loadedDownloads);

      notifyListeners();
    } catch (e) {
      debugPrint(
        'Failed to load downloads: $e',
      );
    }
  }

  // ==========================================
  // SAVE DOWNLOADS
  // ==========================================

  Future<void> _saveDownloads() async {
    try {
      final prefs =
      await SharedPreferences.getInstance();

      final data = _downloads
          .map((item) => item.toJson())
          .toList();

      await prefs.setString(
        _storageKey,
        jsonEncode(data),
      );
    } catch (e) {
      debugPrint(
        'Failed to save downloads: $e',
      );
    }
  }

  // ==========================================
  // ADD DOWNLOAD
  // ==========================================

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

  // ==========================================
  // UPDATE PROGRESS
  // ==========================================

  Future<void> updateProgress(
      String id,
      double progress,
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
      status: oldItem.status,
      filePath: oldItem.filePath,
      progress: progress.clamp(0.0, 1.0),
    );

    notifyListeners();

    await _saveDownloads();
  }

  // ==========================================
  // UPDATE STATUS
  // ==========================================

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
      filePath: oldItem.filePath,
      progress: oldItem.progress,
    );

    notifyListeners();

    await _saveDownloads();
  }

  // ==========================================
  // UPDATE FILE PATH
  // ==========================================

  Future<void> updateFilePath(
      String id,
      String filePath,
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
      status: oldItem.status,
      filePath: filePath,
      progress: oldItem.progress,
    );

    notifyListeners();

    await _saveDownloads();
  }

  // ==========================================
  // REMOVE DOWNLOAD
  // ==========================================

  Future<void> removeDownload(
      String id,
      ) async {
    _downloads.removeWhere(
          (item) => item.id == id,
    );

    notifyListeners();

    await _saveDownloads();
  }

  // ==========================================
  // CLEAR ALL DOWNLOADS
  // ==========================================

  Future<void> clearDownloads() async {
    _downloads.clear();

    notifyListeners();

    await _saveDownloads();
  }
}