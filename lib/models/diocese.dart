class Diocese {
  final String id;
  final String name;
  final String provinceId;
  final String? description;

  const Diocese({
    required this.id,
    required this.name,
    required this.provinceId,
    this.description,
  });

  factory Diocese.fromJson(Map<String, dynamic> json) {
    return Diocese(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      provinceId: json['provinceId']?.toString() ??
          json['province_id']?.toString() ??
          '',
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'provinceId': provinceId,
      'description': description,
    };
  }

  Diocese copyWith({
    String? id,
    String? name,
    String? provinceId,
    String? description,
  }) {
    return Diocese(
      id: id ?? this.id,
      name: name ?? this.name,
      provinceId: provinceId ?? this.provinceId,
      description: description ?? this.description,
    );
  }
}