part of '../../pages.dart';

class RuleService {
  RuleService._();

  static final RuleService instance = RuleService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _rulesRef =>
      _firestore.collection('rules');

  Future<List<Map<String, dynamic>>> getRules() async {
    debugPrint('========== GET RULES START ==========');

    final snapshot = await _rulesRef
        .orderBy('createdAt', descending: false)
        .get();

    final results = snapshot.docs.map((doc) {
      return {'docId': doc.id, ...doc.data()};
    }).toList();

    debugPrint('[RULES] total: ${results.length}');
    debugPrint('========== GET RULES END ==========');

    return results;
  }

  Future<void> createRule({
    required String condition,
    required String result,
    required String status,
    required String createdBy,
  }) async {
    debugPrint('========== CREATE RULE START ==========');
    debugPrint('[RULE] condition: $condition');
    debugPrint('[RULE] result: $result');
    debugPrint('[RULE] status: $status');
    debugPrint('[RULE] createdBy: $createdBy');

    await _rulesRef.add({
      'condition': condition,
      'result': result,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
    });

    debugPrint('========== CREATE RULE END ==========');
  }

  Future<void> updateRule({
    required String docId,
    required String condition,
    required String result,
    required String status,
  }) async {
    debugPrint('========== UPDATE RULE START ==========');
    debugPrint('[RULE] docId: $docId');

    await _rulesRef.doc(docId).update({
      'condition': condition,
      'result': result,
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    debugPrint('========== UPDATE RULE END ==========');
  }

  Future<void> deleteRule(String docId) async {
    debugPrint('========== DELETE RULE START ==========');
    debugPrint('[RULE] docId: $docId');

    await _rulesRef.doc(docId).delete();

    debugPrint('========== DELETE RULE END ==========');
  }
}
