class ChurchProfile {
  final String? provinceId;
  final String? dioceseId;
  final String? parishId;

  const ChurchProfile({
    this.provinceId,
    this.dioceseId,
    this.parishId,
  });

  factory ChurchProfile.fromJson(Map<String, dynamic> json) {
    return ChurchProfile(
      provinceId: json['provinceId'] as String?,
      dioceseId: json['dioceseId'] as String?,
      parishId: json['parishId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provinceId': provinceId,
      'dioceseId': dioceseId,
      'parishId': parishId,
    };
  }
}

class AppUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final List<String> roles;
  final ChurchProfile? churchProfile;

  const AppUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.roles,
    this.churchProfile,
  });

  String get fullName => '$firstName $lastName';

  bool hasRole(String role) {
    return roles.contains('super_admin') || roles.contains(role);
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final profile = json['churchProfile'];

    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      roles: (json['roles'] as List<dynamic>? ?? [])
          .map((role) => role.toString())
          .toList(),
      churchProfile: profile is Map<String, dynamic>
          ? ChurchProfile.fromJson(profile)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'roles': roles,
      'churchProfile': churchProfile?.toJson(),
    };
  }
}