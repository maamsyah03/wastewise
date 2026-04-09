class SymptomItem {
  final String docId;
  final int id;
  final String name;
  final String status;

  const SymptomItem({
    required this.docId,
    required this.id,
    required this.name,
    required this.status,
  });

  factory SymptomItem.fromFirestore({
    required String docId,
    required int index,
    required Map<String, dynamic> data,
  }) {
    return SymptomItem(
      docId: docId,
      id: index + 1,
      name: (data['name'] ?? '').toString(),
      status: (data['status'] ?? 'Aktif').toString(),
    );
  }

  SymptomItem copyWith({
    String? docId,
    int? id,
    String? name,
    String? status,
  }) {
    return SymptomItem(
      docId: docId ?? this.docId,
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }
}