part of '../../pages.dart';

class SymptomService {
  SymptomService._();

  static final SymptomService instance = SymptomService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _symptomsRef =>
      _firestore.collection('symptoms');

  Future<List<Map<String, dynamic>>> getSymptoms() async {
    debugPrint('========== GET SYMPTOMS START ==========');

    final snapshot = await _symptomsRef
        .orderBy('createdAt', descending: false)
        .get();

    final results = snapshot.docs.map((doc) {
      return {'docId': doc.id, ...doc.data()};
    }).toList();

    debugPrint('[SYMPTOMS] total: ${results.length}');
    debugPrint('========== GET SYMPTOMS END ==========');

    return results;
  }

  Future<void> createSymptom({
    required String name,
    required String status,
    required String createdBy,
  }) async {
    debugPrint('========== CREATE SYMPTOM START ==========');
    debugPrint('[SYMPTOM] name: $name');
    debugPrint('[SYMPTOM] status: $status');
    debugPrint('[SYMPTOM] createdBy: $createdBy');

    await _symptomsRef.add({
      'name': name,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
    });

    debugPrint('========== CREATE SYMPTOM END ==========');
  }

  Future<void> updateSymptom({
    required String docId,
    required String name,
    required String status,
  }) async {
    debugPrint('========== UPDATE SYMPTOM START ==========');
    debugPrint('[SYMPTOM] docId: $docId');
    debugPrint('[SYMPTOM] name: $name');
    debugPrint('[SYMPTOM] status: $status');

    await _symptomsRef.doc(docId).update({
      'name': name,
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    debugPrint('========== UPDATE SYMPTOM END ==========');
  }

  Future<void> deleteSymptom(String docId) async {
    debugPrint('========== DELETE SYMPTOM START ==========');
    debugPrint('[SYMPTOM] docId: $docId');

    await _symptomsRef.doc(docId).delete();

    debugPrint('========== DELETE SYMPTOM END ==========');
  }
}
