import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloaderService {
  final Dio _dio = Dio();

  Future<String> downloadFile({
    required String downloadUrl,
    required String fileName,
    required void Function(double progress) onProgress,
  }) async {
    if (downloadUrl.trim().isEmpty) {
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

    final filePath =
        '${downloadDirectory.path}/$fileName';

    await _dio.download(
      downloadUrl,
      filePath,
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

    return filePath;
  }

  Future<bool> fileExists(
      String filePath,
      ) async {
    final file = File(filePath);

    return file.exists();
  }

  Future<void> deleteFile(
      String filePath,
      ) async {
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
    }
  }
}