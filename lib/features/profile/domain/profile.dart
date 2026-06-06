class Profile {
  final String id;
  final String name;
  final String email;
  final String passwordHash;

  const Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
  });

  String get avatarInitial => name.isNotEmpty ? name[0].toUpperCase() : '?';

  Profile copyWith({
    String? id,
    String? name,
    String? email,
    String? passwordHash,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }
}
