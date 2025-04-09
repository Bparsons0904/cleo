import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../models/cleaning_history.dart';
import '../services/api_client.dart';

// Then for the CleaningHistoryRepository class, use this implementation:
class CleaningHistoryRepository {
  final ApiClient _apiClient;

  CleaningHistoryRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<CleaningHistory> logCleaning({
    required int releaseId,
    required DateTime cleanedAt,
    String? notes,
  }) async {
    try {
      debugPrint('CleaningHistoryRepository.logCleaning - START');
      final requestData = {
        'releaseId': releaseId,
        'cleanedAt': cleanedAt.toUtc().toIso8601String(),
        'notes': notes,
      };
      
      final response = await _apiClient.post('/cleanings', data: requestData);
      
      // If response is successful but doesn't match expected format, return basic object
      return CleaningHistory(
        id: 0,
        releaseId: releaseId,
        cleanedAt: cleanedAt,
        notes: notes,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<int, int>> getCleaningCounts() async {
    try {
      final response = await _apiClient.get('/cleanings/counts');
      
      // Convert from JSON to Map<int, int>
      final Map<String, dynamic> data = response.data;
      return data.map((key, value) => MapEntry(int.parse(key), value as int));
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

  Future<bool> updateCleaning({
    required int cleaningId,
    required DateTime cleanedAt,
    String? notes,
  }) async {
    try {
      debugPrint('CleaningHistoryRepository.updateCleaning - START');
      final requestData = {
        'cleanedAt': cleanedAt.toUtc().toIso8601String(),
        'notes': notes,
      };
      
      await _apiClient.put('/cleanings/$cleaningId', data: requestData);
      return true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> deleteCleaning(int cleaningId) async {
    try {
      debugPrint('CleaningHistoryRepository.deleteCleaning - START');
      await _apiClient.delete('/cleanings/$cleaningId');
      return true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
}

