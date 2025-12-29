class UserProfile {
  final String id;
  final String username;
  final String fullName;
  final String? avatarUrl;
  final String? bio;
  final double rating;

  UserProfile({
    required this.id,
    required this.username,
    required this.fullName,
    this.avatarUrl,
    this.bio,
    this.rating = 0.0,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    final String first = map['first_name'] ?? '';
    final String last = map['last_name'] ?? '';
    final String computedName = map['full_name'] ?? '$first $last'.trim();

    return UserProfile(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      fullName: computedName.isEmpty ? 'User' : computedName,
      avatarUrl: map['avatar_url'],
      bio: map['bio'],
      rating: (map['rating'] ?? 0.0).toDouble(),
    );
  }
}
