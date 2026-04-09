part of '../../pages.dart';

class ConsultationService {
  ConsultationService._();

  static final instance = ConsultationService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getSymptoms() async {
    final snapshot = await _firestore
        .collection('symptoms')
        .where('status', isEqualTo: 'Aktif')
        .get();

    return snapshot.docs
        .map((e) => (e.data()['name'] ?? '').toString())
        .toList();
  }

  Future<List<Map<String, dynamic>>> getRules() async {
    final snapshot = await _firestore
        .collection('rules')
        .where('status', isEqualTo: 'Aktif')
        .get();

    return snapshot.docs.map((e) => e.data()).toList();
  }

  Future<void> saveConsultation({
    required String userId,
    required List<String> symptoms,
    required String result,
    required String recommendation,
  }) async {
    await _firestore.collection('consultations').add({
      'userId': userId,
      'symptoms': symptoms,
      'result': result,
      'recommendation': recommendation,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> getUserHistory(String userId) async {
    final snapshot = await _firestore
        .collection('consultations')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((e) {
      final data = e.data();
      return {...data, 'id': e.id};
    }).toList();
  }

  Stream<List<Map<String, dynamic>>> streamUserHistory(String userId) {
    return _firestore
        .collection('consultations')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((e) {
            final data = e.data();
            return {...data, 'id': e.id};
          }).toList();
        });
  }
}
