part of '../../pages.dart';

class LoginController extends GetxController {
  late final TextEditingController usernameC;
  late final TextEditingController passwordC;

  final isPasswordHidden = true.obs;
  final isRememberMe = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    usernameC = TextEditingController();
    passwordC = TextEditingController(text: '123456');
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

  Future<void> login() async {
    isLoading.value = true;

    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      final username = usernameC.text.trim();
      final password = passwordC.text.trim();

      final role = _getRoleFromCredential(
        username: username,
        password: password,
      );

      if (role == null) {
        Get.snackbar(
          'Login gagal',
          'Username atau password tidak sesuai',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      Get.snackbar(
        'Berhasil',
        'Login sebagai ${role.name}',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      Get.offAll(() => Dashboard(role: role))!.whenComplete(() {
        usernameC.clear();
        // passwordC.clear();
      });
    } finally {
      isLoading.value = false;
    }
  }

  Role? _getRoleFromCredential({
    required String username,
    required String password,
  }) {
    if (password != '123456') return null;

    switch (username.toLowerCase()) {
      case 'user':
        return Role.user;
      case 'pakar':
        return Role.pakar;
      case 'admin':
        return Role.admin;
      default:
        return null;
    }
  }
}
