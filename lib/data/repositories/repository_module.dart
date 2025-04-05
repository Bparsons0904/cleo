// lib/data/di/repository_module.dart
import 'package:get_it/get_it.dart';
import '../repositories/auth_repository.dart';
import '../repositories/collection_repository.dart';
import '../repositories/cleaning_history_repository.dart';
import '../repositories/play_history_repository.dart';
import '../repositories/stylus_repository.dart';
import '../services/api_client.dart';

final getIt = GetIt.instance;

void setupRepositories() {
  // Register API client
  getIt.registerSingleton<ApiClient>(
    ApiClient(baseUrl: 'https://api.kleioapp.com'),
  );

  // Register repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepository(apiClient: getIt<ApiClient>()),
  );

  getIt.registerSingleton<CollectionRepository>(
    CollectionRepository(apiClient: getIt<ApiClient>()),
  );

  getIt.registerSingleton<StylusRepository>(
    StylusRepository(apiClient: getIt<ApiClient>()),
  );

  getIt.registerSingleton<PlayHistoryRepository>(
    PlayHistoryRepository(apiClient: getIt<ApiClient>()),
  );

  getIt.registerSingleton<CleaningHistoryRepository>(
    CleaningHistoryRepository(apiClient: getIt<ApiClient>()),
  );
}
