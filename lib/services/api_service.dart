import 'package:dio/dio.dart';

import '../models/video_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static const String baseUrl = 'http://10.0.2.2:3000';

  // ==========================================
  // CHECK SERVER
  // ==========================================

  Future<bool> checkServer() async {
    try {
      final response = await _dio.get(
        '$baseUrl/api/health',
      );

      return response.statusCode == 200 &&
          response.data is Map &&
          response.data['success'] == true;
    } on DioException {
      return false;
    } catch (e) {
      return false;
    }
  }

  // ==========================================
  // GET VIDEO INFORMATION
  // ==========================================

  Future<VideoModel> getVideoInfo(
      String url,
      ) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/video/info',
        data: {
          'url': url,
        },
      );

      if (response.data is Map) {
        return VideoModel.fromJson(
          Map<String, dynamic>.from(
            response.data,
          ),
        );
      }

      return VideoModel(
        success: false,
        platform: '',
        sourceUrl: url,
        message:
        'Invalid response received from server.',
      );
    } on DioException catch (e) {
      if (e.response?.data is Map) {
        return VideoModel.fromJson(
          Map<String, dynamic>.from(
            e.response!.data,
          ),
        );
      }

      return VideoModel(
        success: false,
        platform: '',
        sourceUrl: url,
        message: _getErrorMessage(e),
      );
    } catch (e) {
      return VideoModel(
        success: false,
        platform: '',
        sourceUrl: url,
        message: 'Something went wrong.',
      );
    }
  }

  // ==========================================
  // CREATE DOWNLOAD JOB
  // ==========================================

  Future<Map<String, dynamic>> createDownloadJob({
    required String url,
    required String format,
    String? quality,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/video/download',
        data: {
          'url': url,
          'format': format,
          'quality': quality,
        },
      );

      if (response.data is Map) {
        return Map<String, dynamic>.from(
          response.data,
        );
      }

      return {
        'success': false,
        'message':
        'Invalid response received from server.',
      };
    } on DioException catch (e) {
      if (e.response?.data is Map) {
        return Map<String, dynamic>.from(
          e.response!.data,
        );
      }

      return {
        'success': false,
        'message': _getErrorMessage(e),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Something went wrong.',
      };
    }
  }

  // ==========================================
  // ERROR MESSAGE
  // ==========================================

  String _getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out. Please try again.';

      case DioExceptionType.sendTimeout:
        return 'Request timed out. Please try again.';

      case DioExceptionType.receiveTimeout:
        return 'Server response timed out. Please try again.';

      case DioExceptionType.connectionError:
        return 'Could not connect to the server.';

      case DioExceptionType.badResponse:
        return 'Server returned an error.';

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      default:
        return 'Network error. Please try again.';
    }
  }
}