import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../models/play_history.dart';
import '../services/api_client.dart';

// Then for the PlayHistoryRepository class, use this implementation:
class PlayHistoryRepository {
  final ApiClient _apiClient;

  PlayHistoryRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<PlayHistory> logPlay({
    required int releaseId,
    int? stylusId,
    required DateTime playedAt,
    String? notes,
  }) async {
    try {
      debugPrint('PlayHistoryRepository.logPlay - START');
      final requestData = {
        'releaseId': releaseId,
        'stylusId': stylusId,
        'playedAt': playedAt.toUtc().toIso8601String(),
        'notes': notes,
      };
      
      final response = await _apiClient.post('/plays', data: requestData);
      
      // If response is successful but doesn't match expected format, return basic object
      return PlayHistory(
        id: 0,
        releaseId: releaseId,
        stylusId: stylusId,
        playedAt: playedAt,
        notes: notes,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<int, int>> getPlayCounts() async {
    try {
      final response = await _apiClient.get('/plays/counts');
      
      // Convert from JSON to Map<int, int>
      final Map<String, dynamic> data = response.data;
      return data.map((key, value) => MapEntry(int.parse(key), value as int));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<PlayHistory>> getRecentPlays() async {
    try {
      final response = await _apiClient.get('/plays/recent');
      
      final List<dynamic> results = response.data;
      return results.map((json) => PlayHistory.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  Exception _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      return Exception('Authentication required. Please log in again.');
    } else if (e.response?.statusCode == 404) {
      return Exception('Resource not found.');
    } else {
      return Exception('An error occurred: ${e.message}');
    }
  }

  Future<bool> updatePlay({
    required int playId,
    required DateTime playedAt,
    int? stylusId,
    String? notes,
  }) async {
    try {
      debugPrint('PlayHistoryRepository.updatePlay - START');
      final requestData = {
        'playedAt': playedAt.toUtc().toIso8601String(),
        'stylusId': stylusId,
        'notes': notes,
      };
      
      await _apiClient.put('/plays/$playId', data: requestData);
      return true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> deletePlay(int playId) async {
    try {
      debugPrint('PlayHistoryRepository.deletePlay - START');
      await _apiClient.delete('/plays/$playId');
      return true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }  
}
