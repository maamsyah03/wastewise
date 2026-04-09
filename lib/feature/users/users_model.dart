class UserManagementItem {
  final String docId;
  final int id;
  final String name;
  final String email;
  final String role;
  final String status;

  const UserManagementItem({
    required this.docId,
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
  });

  factory UserManagementItem.fromFirestore({
    required String docId,
    required int index,
    required Map<String, dynamic> data,
  }) {
    return UserManagementItem(
      docId: docId,
      id: index + 1,
      name: (data['name'] ?? data['username'] ?? '-').toString(),
      email: (data['email'] ?? '-').toString(),
      role: _capitalize((data['role'] ?? 'user').toString()),
      status: (data['status'] ?? 'Aktif').toString(),
    );
  }

  UserManagementItem copyWith({
    String? docId,
    int? id,
    String? name,
    String? email,
    String? role,
    String? status,
  }) {
    return UserManagementItem(
      docId: docId ?? this.docId,
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }

  static String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }
}
