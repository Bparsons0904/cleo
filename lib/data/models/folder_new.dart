import 'package:freezed_annotation/freezed_annotation.dart';

part 'folder_new.freezed.dart';
part 'folder_new.g.dart';

/// Folder model for Waugzee API
/// Represents a Discogs collection folder
@freezed
class FolderNew with _$FolderNew {
  const factory FolderNew({
    required int id, // Discogs folder ID
    required String userId, // UUID
    required String name,
    @Default(0) int count,
    required String resourceUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _FolderNew;

  factory FolderNew.fromJson(Map<String, dynamic> json) =>
      _$FolderNewFromJson(json);
}
