class Format {
  final int id;
  final int releaseId;
  final String name;
  final int qty;
  final List<String> descriptions;

  Format({
    required this.id,
    required this.releaseId,
    required this.name,
    required this.qty,
    required this.descriptions,
  });

  factory Format.fromJson(Map<String, dynamic> json) {
    return Format(
      id: json['id'] ?? 0,
      releaseId: json['releaseId'] ?? 0,
      name: json['name'] ?? '',
      qty: json['qty'] ?? 0,
      descriptions: (json['descriptions'] as List?)
          ?.map((desc) => desc.toString())
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'releaseId': releaseId,
      'name': name,
      'qty': qty,
      'descriptions': descriptions,
    };
  }
}
