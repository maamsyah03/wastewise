part of '../../pages.dart';

class UserDashboardService {
  UserDashboardService._();

  static final UserDashboardService instance = UserDashboardService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUserDashboardSummary(String userId) async {
    debugPrint('========== USER DASHBOARD SUMMARY START ==========');
    debugPrint('[USER DASHBOARD] userId = $userId');

    final snapshot = await _firestore
        .collection('consultations')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    debugPrint(
      '[USER DASHBOARD] total consultation docs = ${snapshot.docs.length}',
    );

    final docs = snapshot.docs.map((e) => e.data()).toList();

    final totalConsultations = docs.length;

    final Map<String, int> resultCounter = {};
    for (final item in docs) {
      final result = (item['result'] ?? '-').toString().trim();
      if (result.isEmpty) continue;
      resultCounter[result] = (resultCounter[result] ?? 0) + 1;
    }

    String mostFrequentResult = '-';
    if (resultCounter.isNotEmpty) {
      final sorted = resultCounter.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      mostFrequentResult = sorted.first.key;
    }

    final recentActivities = docs.take(5).map((item) {
      final createdAt = item['createdAt'] as Timestamp?;
      final dateText = createdAt != null
          ? createdAt.toDate().toString().split(' ').first
          : '-';

      return {
        'title': (item['result'] ?? '-').toString(),
        'subtitle': (item['recommendation'] ?? '-').toString(),
        'date': dateText,
      };
    }).toList();

    debugPrint('[USER DASHBOARD] totalConsultations = $totalConsultations');
    debugPrint('[USER DASHBOARD] mostFrequentResult = $mostFrequentResult');
    debugPrint(
      '[USER DASHBOARD] recentActivities count = ${recentActivities.length}',
    );
    debugPrint('========== USER DASHBOARD SUMMARY END ==========');

    return {
      'totalConsultations': totalConsultations,
      'mostFrequentResult': mostFrequentResult,
      'recentActivities': recentActivities,
    };
  }
}
