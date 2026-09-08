class Province {
  final String id;
  final String name;
  final String? description;

  const Province({
    required this.id,
    required this.name,
    this.description,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  Province copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return Province(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}