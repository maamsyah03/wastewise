part of '../../pages.dart';

class AdminService {
  AdminService._();

  static final AdminService instance = AdminService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getUsers() async {
    final snapshot = await _firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((e) {
      return {...e.data(), 'docId': e.id};
    }).toList();
  }

  Future<void> updateUser({
    required String docId,
    required String name,
    required String role,
    required String status,
  }) async {
    await _firestore.collection('users').doc(docId).update({
      'name': name,
      'role': role.toLowerCase(),
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteUser(String docId) async {
    await _firestore.collection('users').doc(docId).delete();
  }

  Future<List<Map<String, dynamic>>> getConsultations() async {
    final snapshot = await _firestore
        .collection('consultations')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((e) {
      return {...e.data(), 'docId': e.id};
    }).toList();
  }

  Future<Map<String, dynamic>> getAdminDashboardSummary() async {
    final usersSnapshot = await _firestore.collection('users').get();
    final consultationsSnapshot = await _firestore
        .collection('consultations')
        .get();
    final symptomsSnapshot = await _firestore.collection('symptoms').get();
    final rulesSnapshot = await _firestore.collection('rules').get();

    final consultations = consultationsSnapshot.docs
        .map((e) => e.data())
        .toList();

    final Map<String, int> resultCounter = {};
    for (final item in consultations) {
      final result = (item['result'] ?? 'Tidak diketahui').toString();
      resultCounter[result] = (resultCounter[result] ?? 0) + 1;
    }

    final List<MapEntry<String, int>> sortedResults =
        resultCounter.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return {
      'totalUsers': usersSnapshot.docs.length,
      'totalConsultations': consultationsSnapshot.docs.length,
      'totalSymptoms': symptomsSnapshot.docs.length,
      'totalRules': rulesSnapshot.docs.length,
      'resultCounter': sortedResults,
    };
  }
}
