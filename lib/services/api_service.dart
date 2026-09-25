import 'package:dio/dio.dart';

import '../models/video_model.dart';

class ApiService {
  final Dio _dio = Dio();

  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<bool> checkServer() async {
    try {
      final response = await _dio.get(
        '$baseUrl/api/health',
      );

      return response.statusCode == 200 &&
          response.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

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

      return VideoModel.fromJson(
        Map<String, dynamic>.from(
          response.data,
        ),
      );
    } on DioException catch (e) {
      if (e.response != null &&
          e.response!.data is Map) {
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
        message: 'Could not connect to the server.',
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

      return Map<String, dynamic>.from(
        response.data,
      );
    } on DioException catch (e) {
      if (e.response != null &&
          e.response!.data is Map) {
        return Map<String, dynamic>.from(
          e.response!.data,
        );
      }

      return {
        'success': false,
        'message': 'Could not connect to the server.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Something went wrong.',
      };
    }
  }
}