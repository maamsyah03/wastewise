class SymptomItem {
  final int id;
  final String name;
  final String status;

  const SymptomItem({
    required this.id,
    required this.name,
    required this.status,
  });

  SymptomItem copyWith({
    int? id,
    String? name,
    String? status,
  }) {
    return SymptomItem(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }
}