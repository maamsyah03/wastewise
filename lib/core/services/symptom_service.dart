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
        .get(const GetOptions(source: Source.server));

    final results = snapshot.docs.map((doc) {
      return {
        'docId': doc.id,
        ...doc.data(),
      };
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
      'name': name.trim(),
      'status': status.trim(),
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
    final cleanDocId = docId.trim();

    debugPrint('========== UPDATE SYMPTOM START ==========');
    debugPrint('[SYMPTOM] docId: $cleanDocId');
    debugPrint('[SYMPTOM] name: $name');
    debugPrint('[SYMPTOM] status: $status');

    if (cleanDocId.isEmpty) {
      throw Exception('docId gejala kosong');
    }

    await _symptomsRef.doc(cleanDocId).update({
      'name': name.trim(),
      'status': status.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    debugPrint('========== UPDATE SYMPTOM END ==========');
  }

  Future<void> deleteSymptom(String docId) async {
    final cleanDocId = docId.trim();

    debugPrint('========== DELETE SYMPTOM START ==========');
    debugPrint('[SYMPTOM] docId: $cleanDocId');

    if (cleanDocId.isEmpty) {
      throw Exception('docId gejala kosong');
    }

    final docRef = _symptomsRef.doc(cleanDocId);
    final docSnap = await docRef.get(const GetOptions(source: Source.server));

    debugPrint('[SYMPTOM] exists before delete: ${docSnap.exists}');

    if (!docSnap.exists) {
      throw Exception('Dokumen gejala tidak ditemukan di Firestore');
    }

    await docRef.delete();

    final checkAfterDelete =
    await docRef.get(const GetOptions(source: Source.server));

    debugPrint('[SYMPTOM] exists after delete: ${checkAfterDelete.exists}');
    debugPrint('========== DELETE SYMPTOM END ==========');

    if (checkAfterDelete.exists) {
      throw Exception('Dokumen gejala gagal terhapus dari Firestore');
    }
  }
}