part of '../../pages.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late final SignupController controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<SignupController>()
        ? Get.find<SignupController>()
        : Get.put(SignupController());
  }

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 700;

  bool _isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 700 && width < 1100;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);
    final isTablet = _isTablet(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 24,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: isMobile
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildBrandPanel(context, isMobile: true),
                        const SizedBox(height: 20),
                        _buildSignupForm(context, isMobile: true),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: isTablet ? 5 : 6,
                          child: _buildBrandPanel(context),
                        ),
                        const SizedBox(width: 24),
                        Flexible(
                          flex: isTablet ? 5 : 4,
                          child: _buildSignupForm(context),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandPanel(BuildContext context, {bool isMobile = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 36),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F5EF7), Color(0xFF2B8CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.eco_rounded,
              size: 36,
              color: Color(0xFF0F5EF7),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Buat Akun WasteWise',
            style: TextStyle(
              fontSize: isMobile ? 28 : 40,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Daftarkan akun baru untuk mulai mengakses fitur identifikasi dan rekomendasi pengelolaan sampah.',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: Colors.white.withOpacity(0.94),
              height: 1.75,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm(BuildContext context, {bool isMobile = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Akun',
              style: TextStyle(
                fontSize: isMobile ? 24 : 30,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF101828),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lengkapi data berikut untuk membuat akun baru.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 22),
            Text('Role', style: _fieldLabelStyle()),
            const SizedBox(height: 8),
            Obx(
                  () => DropdownButtonFormField<String>(
                value: controller.selectedRole.value,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.4,
                    ),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'user', child: Text('User')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                ],
                onChanged: controller.setRole,
              ),
            ),
            const SizedBox(height: 18),
            Text('Email', style: _fieldLabelStyle()),
            const SizedBox(height: 8),
            TextFieldCustom(
              hintText: 'Masukkan email',
              lebel: '',
              controller: controller.usernameC,
              validator: controller.validateUsername,
              cursorHeight: 20,
              cursorColor: Colors.black87,
              fillColor: const Color(0xFFF8FAFC),
              hintColor: Colors.grey,
              borderRadius: 16,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            const SizedBox(height: 18),
            Text('Password', style: _fieldLabelStyle()),
            const SizedBox(height: 8),
            Obx(
              () => TextFieldCustom(
                hintText: 'Masukkan password',
                lebel: '',
                controller: controller.passwordC,
                validator: controller.validatePassword,
                cursorHeight: 20,
                cursorColor: Colors.black87,
                obscureText: controller.isPasswordHidden.value,
                fillColor: const Color(0xFFF8FAFC),
                hintColor: Colors.grey,
                borderRadius: 16,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                onChanged: (_) {
                  _formKey.currentState?.validate();
                },
                suffixIcon: IconButton(
                  onPressed: controller.togglePasswordVisibility,
                  icon: Icon(
                    controller.isPasswordHidden.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text('Konfirmasi Password', style: _fieldLabelStyle()),
            const SizedBox(height: 8),
            Obx(
              () => TextFieldCustom(
                hintText: 'Ulangi password',
                lebel: '',
                controller: controller.confirmPasswordC,
                validator: controller.validateConfirmPassword,
                cursorHeight: 20,
                cursorColor: Colors.black87,
                obscureText: controller.isConfirmPasswordHidden.value,
                fillColor: const Color(0xFFF8FAFC),
                hintColor: Colors.grey,
                borderRadius: 16,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                onChanged: (_) {
                  _formKey.currentState?.validate();
                },
                suffixIcon: IconButton(
                  onPressed: controller.toggleConfirmPasswordVisibility,
                  icon: Icon(
                    controller.isConfirmPasswordHidden.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ReusableButton(
                  label: controller.isLoading.value ? 'Memproses...' : 'Daftar',
                  onTap: controller.isLoading.value
                      ? () {}
                      : () {
                          final isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (!isValid) return;
                          controller.signup();
                        },
                  backgroundColor: const Color(0xFF0F5EF7),
                  textColor: Colors.white,
                  fontWeight: FontWeight.w700,
                  borderRadius: 16,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  margin: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Wrap(
                spacing: 6,
                children: [
                  Text(
                    'Sudah punya akun?',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  InkWell(
                    onTap: controller.goToLogin,
                    child: const Text(
                      'Masuk di sini',
                      style: TextStyle(
                        color: Color(0xFF0F5EF7),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _fieldLabelStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Color(0xFF344054),
    );
  }
}
