import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloaderService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(minutes: 10),
      sendTimeout: const Duration(seconds: 15),
    ),
  );

  Future<String> downloadFile({
    required String downloadUrl,
    required String fileName,
    required void Function(double progress) onProgress,
  }) async {
    final url = downloadUrl.trim();

    if (url.isEmpty) {
      throw Exception('Download URL is empty.');
    }

    final directory =
    await getApplicationDocumentsDirectory();

    final downloadDirectory = Directory(
      '${directory.path}/downloads',
    );

    if (!await downloadDirectory.exists()) {
      await downloadDirectory.create(
        recursive: true,
      );
    }

    final safeFileName = _sanitizeFileName(
      fileName,
    );

    final filePath =
        '${downloadDirectory.path}/$safeFileName';

    await _dio.download(
      url,
      filePath,
      deleteOnError: true,
      onReceiveProgress: (received, total) {
        if (total > 0) {
          final progress =
              received / total;

          onProgress(
            progress.clamp(0.0, 1.0),
          );
        }
      },
    );

    final file = File(filePath);

    if (!await file.exists()) {
      throw Exception(
        'Downloaded file was not found.',
      );
    }

    return filePath;
  }

  Future<bool> fileExists(
      String filePath,
      ) async {
    if (filePath.trim().isEmpty) {
      return false;
    }

    final file = File(filePath);

    return file.exists();
  }

  Future<void> deleteFile(
      String filePath,
      ) async {
    if (filePath.trim().isEmpty) {
      return;
    }

    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
    }
  }

  String _sanitizeFileName(
      String fileName,
      ) {
    var name = fileName.trim();

    if (name.isEmpty) {
      name = 'download';
    }

    name = name.replaceAll(
      RegExp(r'[<>:"/\\|?*\x00-\x1F]'),
      '_',
    );

    name = name.replaceAll(
      RegExp(r'\s+'),
      '_',
    );

    if (name.length > 100) {
      name = name.substring(0, 100);
    }

    return name;
  }
}