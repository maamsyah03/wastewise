part of '../../pages.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final LoginController controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<LoginController>()
        ? Get.find<LoginController>()
        : Get.put(LoginController());
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
                        _buildFormPanel(context, isMobile: true),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: isTablet ? 5 : 6,
                          child: _buildBrandPanel(context),
                        ),
                        const SizedBox(width: 24),
                        Flexible(
                          flex: isTablet ? 5 : 4,
                          child: _buildFormPanel(context),
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
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F5EF7).withOpacity(0.16),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogoBox(),
          const SizedBox(height: 28),
          Text(
            'WasteWise',
            style: TextStyle(
              fontSize: isMobile ? 30 : 42,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Platform sistem pakar untuk membantu identifikasi jenis sampah dan menentukan pengelolaan yang tepat secara cepat, terstruktur, dan mudah dipahami.',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: Colors.white.withOpacity(0.94),
              height: 1.75,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withOpacity(0.16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _brandItem(
                  icon: Icons.track_changes_outlined,
                  title: 'Tujuan Utama',
                  description:
                      'Membantu masyarakat mengenali karakteristik sampah dan memperoleh rekomendasi pengelolaan yang sesuai.',
                ),
                const SizedBox(height: 16),
                _brandItem(
                  icon: Icons.psychology_alt_outlined,
                  title: 'Metode Sistem',
                  description:
                      'Sistem menggunakan forward chaining untuk menghasilkan kesimpulan berdasarkan ciri sampah yang dipilih pengguna.',
                ),
                const SizedBox(height: 16),
                _brandItem(
                  icon: Icons.recycling_outlined,
                  title: 'Dampak Penggunaan',
                  description:
                      'Mendorong pengelolaan sampah yang lebih tepat, edukatif, dan mudah diterapkan dalam lingkungan masyarakat.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              InfoBadge(
                icon: Icons.search_outlined,
                label: 'Identifikasi',
                sublabel: 'Kenali jenis sampah',
              ),
              InfoBadge(
                icon: Icons.lightbulb_outline,
                label: 'Rekomendasi',
                sublabel: 'Saran pengelolaan',
              ),
              InfoBadge(
                icon: Icons.school_outlined,
                label: 'Edukasi',
                sublabel: 'Belajar lebih mudah',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _brandItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.16),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.white, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.92),
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoBox() {
    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Icon(Icons.eco_rounded, size: 36, color: Color(0xFF0F5EF7)),
    );
  }

  Widget _buildFormPanel(BuildContext context, {bool isMobile = false}) {
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
              'Masuk ke Akun',
              style: TextStyle(
                fontSize: isMobile ? 24 : 30,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF101828),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Masuk untuk mulai menggunakan layanan identifikasi sampah di WasteWise.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
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
              prefixIcon: Icon(
                Icons.person_outline,
                color: Colors.grey.shade600,
                size: 20,
              ),
              enabledBorderSide: const BorderSide(color: Color(0xFFD0D5DD)),
              focusedBorderSide: const BorderSide(
                color: Color(0xFF0F5EF7),
                width: 1.4,
              ),
              errorBorderSide: const BorderSide(color: Colors.red),
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
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                suffixIcon: IconButton(
                  onPressed: controller.togglePasswordVisibility,
                  icon: Icon(
                    controller.isPasswordHidden.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                ),
                enabledBorderSide: const BorderSide(color: Color(0xFFD0D5DD)),
                focusedBorderSide: const BorderSide(
                  color: Color(0xFF0F5EF7),
                  width: 1.4,
                ),
                errorBorderSide: const BorderSide(color: Colors.red),
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: 0.95,
                        child: Checkbox(
                          value: controller.isRememberMe.value,
                          onChanged: controller.toggleRememberMe,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          activeColor: const Color(0xFF0F5EF7),
                        ),
                      ),
                      const Text(
                        'Ingat saya',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF344054),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: controller.onForgotPassword,
                    child: const Text('Lupa password?'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ReusableButton(
                  label: controller.isLoading.value ? 'Memproses...' : 'Masuk',
                  onTap: controller.isLoading.value
                      ? () {}
                      : () {
                          final isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (!isValid) return;
                          controller.login();
                        },
                  backgroundColor: const Color(0xFF0F5EF7),
                  textColor: Colors.white,
                  fontWeight: FontWeight.w700,
                  borderRadius: 16,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  margin: EdgeInsets.zero,
                  icon: controller.isLoading.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                children: [
                  Text(
                    'Belum punya akun?',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  InkWell(
                    onTap: controller.goToSignup,
                    child: const Text(
                      'Daftar di sini',
                      style: TextStyle(
                        color: Color(0xFF0F5EF7),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Color(0xFF0F5EF7),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Login digunakan untuk pengguna umum yang ingin melakukan konsultasi identifikasi dan mendapatkan rekomendasi pengelolaan sampah.',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.55,
                        fontSize: 13,
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

class InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;

  const InfoBadge({
    super.key,
    required this.icon,
    required this.label,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sublabel,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.86),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
