class AuthenticatedUser {
  final String schoolId;
  final String gender;
  final String userId;
  final String userName;
  final String studentClass;
  final String board;
  final String photoUrl;
  final bool isRegistered;
  final String groupId;

  const AuthenticatedUser({
    required this.schoolId,
    required this.gender,
    required this.userId,
    required this.userName,
    required this.studentClass,
    required this.board,
    required this.photoUrl,
    required this.isRegistered,
    required this.groupId,
  });

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUser(
      schoolId: json['schoolId'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      studentClass: json['studentClass'] as String? ?? '',
      board: json['board'] as String? ?? '',
      photoUrl: json['photoUrl'] as String? ?? '',
      isRegistered: json['isRegistered'] as bool? ?? false,
      groupId: json['groupId'] as String? ?? '',
    );
  }
}