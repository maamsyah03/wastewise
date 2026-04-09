part of '../../pages.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String username,
    required String role,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'username': username,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return credential;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<String?> getUserRole(String uid) async {
    debugPrint('========== GET USER ROLE START ==========');
    debugPrint('[ROLE] UID: $uid');

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    debugPrint('[ROLE] EXISTS: ${doc.exists}');
    debugPrint('[ROLE] DATA: ${doc.data()}');

    if (!doc.exists) {
      debugPrint('[ROLE][ERROR] Document users/$uid tidak ditemukan');
      debugPrint('========== GET USER ROLE END ==========');
      return null;
    }

    final role = doc.data()?['role'] as String?;
    debugPrint('[ROLE] role field: $role');
    debugPrint('========== GET USER ROLE END ==========');

    return role;
  }

  Future<void> createPakarByAdmin({
    required String username,
    required String email,
    required String password,
  }) async {
    final secondaryApp = await Firebase.initializeApp(
      name: 'secondaryApp-${DateTime.now().millisecondsSinceEpoch}',
      options: DefaultFirebaseOptions.currentPlatform,
    );

    try {
      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);

      final credential = await secondaryAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('User pakar gagal dibuat');
      }

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'username': username,
        'email': email,
        'role': 'pakar',
        'status': 'Aktif',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await secondaryAuth.signOut();
    } finally {
      await secondaryApp.delete();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
