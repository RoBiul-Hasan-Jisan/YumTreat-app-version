/// Mirrors the `req.user` object attached by backend/src/middleware/auth.js
/// and returned by GET /api/auth/account as `{ profileDetails }`.
class UserProfile {
  final String id;
  final String firebaseUid;
  final String email;
  final String name;
  final String photoURL;
  final String role; // "user" | "admin"

  UserProfile({
    required this.id,
    required this.firebaseUid,
    required this.email,
    required this.name,
    required this.photoURL,
    required this.role,
  });

  bool get isAdmin => role == 'admin';

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      firebaseUid: json['firebaseUid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      photoURL: json['photoURL'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
    );
  }
}
