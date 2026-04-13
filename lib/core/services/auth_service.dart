part of '../../pages.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .get(const GetOptions(source: Source.server));

      return doc.data();
    } catch (e) {
      debugPrint('[AUTH][getUserProfile][SERVER ERROR] $e');

      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    }
  }

  Future<String?> getUserRole(String uid) async {
    final data = await getUserProfile(uid);
    return data?['role']?.toString();
  }

  Future<String?> getUserStatus(String uid) async {
    final data = await getUserProfile(uid);
    return data?['status']?.toString();
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String username,
    required String role,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email.trim(),
        'username': username.trim(),
        'role': role.trim().toLowerCase(),
        'status': 'Aktif',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    return credential;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
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
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('User pakar gagal dibuat');
      }

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'username': username.trim(),
        'email': email.trim(),
        'role': 'pakar',
        'status': 'Aktif',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
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