class UserManagementItem {
  final int id;
  final String name;
  final String username;
  final String role;
  final String status;

  const UserManagementItem({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    required this.status,
  });

  UserManagementItem copyWith({
    int? id,
    String? name,
    String? username,
    String? role,
    String? status,
  }) {
    return UserManagementItem(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }
}