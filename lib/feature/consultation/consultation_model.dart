class ConsultationResult {
  final String title;
  final String category;
  final String recommendation;
  final List<String> selectedSymptoms;

  const ConsultationResult({
    required this.title,
    required this.category,
    required this.recommendation,
    required this.selectedSymptoms,
  });
}