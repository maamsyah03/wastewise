part of '../../pages.dart';

class PakarDashboardService {
  PakarDashboardService._();

  static final PakarDashboardService instance = PakarDashboardService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getPakarDashboardSummary() async {
    final symptomsSnap = await _firestore.collection('symptoms').get();
    final rulesSnap = await _firestore.collection('rules').get();

    final symptomsDocs = symptomsSnap.docs;
    final rulesDocs = rulesSnap.docs;

    final totalSymptoms = symptomsDocs.length;
    final totalRules = rulesDocs.length;

    final activeSymptoms = symptomsDocs.where((doc) {
      final status = (doc.data()['status'] ?? '').toString().toLowerCase();
      return status == 'aktif';
    }).length;

    final inactiveSymptoms = symptomsDocs.where((doc) {
      final status = (doc.data()['status'] ?? '').toString().toLowerCase();
      return status == 'nonaktif';
    }).length;

    final activeRules = rulesDocs.where((doc) {
      final status = (doc.data()['status'] ?? '').toString().toLowerCase();
      return status == 'aktif';
    }).length;

    final inactiveRules = rulesDocs.where((doc) {
      final status = (doc.data()['status'] ?? '').toString().toLowerCase();
      return status == 'nonaktif';
    }).length;

    final resultCounter = <String, int>{};
    for (final doc in rulesDocs) {
      final result = (doc.data()['result'] ?? 'Tidak diketahui')
          .toString()
          .trim();
      if (result.isEmpty) continue;
      resultCounter[result] = (resultCounter[result] ?? 0) + 1;
    }

    final sortedResults = resultCounter.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final recentActivities = <Map<String, dynamic>>[];

    for (final doc in symptomsDocs) {
      final data = doc.data();
      recentActivities.add({
        'type': 'symptom',
        'title': 'Gejala: ${(data['name'] ?? '-').toString()}',
        'subtitle': 'Status ${(data['status'] ?? '-').toString()}',
        'time': data['updatedAt'] ?? data['createdAt'],
      });
    }

    for (final doc in rulesDocs) {
      final data = doc.data();
      recentActivities.add({
        'type': 'rule',
        'title': 'Rule: ${(data['result'] ?? '-').toString()}',
        'subtitle': 'Kondisi ${(data['condition'] ?? '-').toString()}',
        'time': data['updatedAt'] ?? data['createdAt'],
      });
    }

    recentActivities.sort((a, b) {
      final aTime = a['time'];
      final bTime = b['time'];

      if (aTime is Timestamp && bTime is Timestamp) {
        return bTime.compareTo(aTime);
      }
      return 0;
    });

    return {
      'totalSymptoms': totalSymptoms,
      'totalRules': totalRules,
      'activeSymptoms': activeSymptoms,
      'inactiveSymptoms': inactiveSymptoms,
      'activeRules': activeRules,
      'inactiveRules': inactiveRules,
      'resultCounter': sortedResults,
      'recentActivities': recentActivities.take(5).toList(),
    };
  }
}
