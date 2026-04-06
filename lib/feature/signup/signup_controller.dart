part of '../../pages.dart';

class SignupController extends GetxController {
  late final TextEditingController usernameC;
  late final TextEditingController passwordC;
  late final TextEditingController confirmPasswordC;

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

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
      return 'Username wajib diisi';
    }
    if (value.trim().length < 3) {
      return 'Username minimal 3 karakter';
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
    isLoading.value = true;

    try {
      await Future.delayed(const Duration(milliseconds: 1200));

      Get.snackbar(
        'Pendaftaran berhasil',
        'Akun berhasil dibuat, silakan login',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      usernameC.clear();
      passwordC.clear();
      confirmPasswordC.clear();

      Get.off(() => const Login());
    } finally {
      isLoading.value = false;
    }
  }
}