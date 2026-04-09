part of '../../pages.dart';

class SignupController extends GetxController {
  late final TextEditingController usernameC;
  late final TextEditingController passwordC;
  late final TextEditingController confirmPasswordC;

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  final AuthService _authService = AuthService.instance;
  final selectedRole = 'user'.obs;
  final allowedSignupRoles = const ['user', 'admin'];

  void setRole(String? value) {
    if (value != null && allowedSignupRoles.contains(value)) {
      selectedRole.value = value;
    }
  }

  @override
  void onInit() {
    super.onInit();
    usernameC = TextEditingController();
    passwordC = TextEditingController();
    confirmPasswordC = TextEditingController();
  }

  @override
  void onClose() {
    usernameC.dispose();
    passwordC.dispose();
    confirmPasswordC.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void goToLogin() {
    Get.off(() => const Login());
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }
    if (value != passwordC.text) {
      return 'Konfirmasi password tidak sama';
    }
    return null;
  }

  Future<void> signup() async {
    if (passwordC.text.trim() != confirmPasswordC.text.trim()) {
      Get.snackbar(
        'Validasi',
        'Password dan konfirmasi password tidak sama',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;

    try {
      final email = usernameC.text.trim();
      final password = passwordC.text.trim();

      await _authService.signUp(
        email: email,
        password: password,
        username: email.split('@').first,
        role: selectedRole.value,
      );

      Get.snackbar(
        'Pendaftaran berhasil',
        'Akun berhasil dibuat, silakan login',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      usernameC.clear();
      passwordC.clear();
      confirmPasswordC.clear();
      selectedRole.value = 'user';

      Get.off(() => const Login());
    } on FirebaseAuthException catch (e) {
      String message = 'Pendaftaran gagal';
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email sudah terdaftar';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid';
          break;
        case 'weak-password':
          message = 'Password terlalu lemah';
          break;
      }

      Get.snackbar(
        'Pendaftaran gagal',
        message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.snackbar(
        'Pendaftaran gagal',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
