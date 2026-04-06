part of '../../pages.dart';

class LoginController extends GetxController {
  late final TextEditingController usernameC;
  late final TextEditingController passwordC;

  final isPasswordHidden = true.obs;
  final isRememberMe = false.obs;
  final isLoading = false.obs;

  final AuthService _authService = AuthService.instance;

  @override
  void onInit() {
    super.onInit();
    usernameC = TextEditingController();
    passwordC = TextEditingController();
  }

  @override
  void onClose() {
    usernameC.dispose();
    passwordC.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleRememberMe(bool? value) {
    isRememberMe.value = value ?? false;
  }

  void goToSignup() {
    Get.to(() => const Signup());
  }

  void onForgotPassword() {
    Get.snackbar(
      'Info',
      'Fitur lupa password belum tersedia',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi';
    }
    if (!GetUtils.isEmail(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  Future<void> login() async {
    isLoading.value = true;

    try {
      final email = usernameC.text.trim();
      final password = passwordC.text.trim();

      final credential = await _authService.signIn(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User tidak ditemukan',
        );
      }

      final roleString = await _authService.getUserRole(uid);

      if (roleString == null) {
        Get.snackbar(
          'Login gagal',
          'Role user tidak ditemukan di database',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      final role = _mapRole(roleString);

      Get.snackbar(
        'Berhasil',
        'Login sebagai ${role.name}',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      usernameC.clear();
      passwordC.clear();

      Get.offAll(() => Dashboard(role: role));
    } on FirebaseAuthException catch (e) {
      String message = 'Login gagal';
      switch (e.code) {
        case 'invalid-credential':
          message = 'Email atau password salah';
          break;
        case 'user-not-found':
          message = 'User tidak ditemukan';
          break;
        case 'wrong-password':
          message = 'Password salah';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid';
          break;
      }

      Get.snackbar(
        'Login gagal',
        message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.snackbar(
        'Login gagal',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Role _mapRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Role.admin;
      case 'pakar':
        return Role.pakar;
      default:
        return Role.user;
    }
  }
}