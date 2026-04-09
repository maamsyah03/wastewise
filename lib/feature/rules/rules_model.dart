
class RuleItemModel {
  final String docId;
  final int id;
  final String condition;
  final String result;
  final String status;

  const RuleItemModel({
    required this.docId,
    required this.id,
    required this.condition,
    required this.result,
    required this.status,
  });

  factory RuleItemModel.fromFirestore({
    required String docId,
    required int index,
    required Map<String, dynamic> data,
  }) {
    return RuleItemModel(
      docId: docId,
      id: index + 1,
      condition: (data['condition'] ?? '').toString(),
      result: (data['result'] ?? '').toString(),
      status: (data['status'] ?? 'Aktif').toString(),
    );
  }

  RuleItemModel copyWith({
    String? docId,
    int? id,
    String? condition,
    String? result,
    String? status,
  }) {
    return RuleItemModel(
      docId: docId ?? this.docId,
      id: id ?? this.id,
      condition: condition ?? this.condition,
      result: result ?? this.result,
      status: status ?? this.status,
    );
  }
}