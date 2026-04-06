class RuleItemModel {
  final int id;
  final String condition;
  final String result;
  final String status;

  const RuleItemModel({
    required this.id,
    required this.condition,
    required this.result,
    required this.status,
  });

  RuleItemModel copyWith({
    int? id,
    String? condition,
    String? result,
    String? status,
  }) {
    return RuleItemModel(
      id: id ?? this.id,
      condition: condition ?? this.condition,
      result: result ?? this.result,
      status: status ?? this.status,
    );
  }
}