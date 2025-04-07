class ReleaseNote {
  final int releaseId;
  final int fieldId;
  final String value;

  ReleaseNote({
    required this.releaseId,
    required this.fieldId,
    required this.value,
  });

  factory ReleaseNote.fromJson(Map<String, dynamic> json) {
    return ReleaseNote(
      releaseId: json['releaseId'] ?? 0,
      fieldId: json['fieldId'] ?? 0,
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'releaseId': releaseId,
      'fieldId': fieldId,
      'value': value,
    };
  }
}
