class Parish {
  final String id;
  final String name;
  final String dioceseId;

  final String? location;
  final String? address;
  final String? phone;
  final String? email;

  const Parish({
    required this.id,
    required this.name,
    required this.dioceseId,
    this.location,
    this.address,
    this.phone,
    this.email,
  });

  factory Parish.fromJson(Map<String, dynamic> json) {
    return Parish(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      dioceseId:
          json['dioceseId']?.toString() ??
          json['diocese_id']?.toString() ??
          '',
      location: json['location']?.toString(),
      address: json['address']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dioceseId': dioceseId,
      'location': location,
      'address': address,
      'phone': phone,
      'email': email,
    };
  }

  Parish copyWith({
    String? id,
    String? name,
    String? dioceseId,
    String? location,
    String? address,
    String? phone,
    String? email,
  }) {
    return Parish(
      id: id ?? this.id,
      name: name ?? this.name,
      dioceseId: dioceseId ?? this.dioceseId,
      location: location ?? this.location,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }
}