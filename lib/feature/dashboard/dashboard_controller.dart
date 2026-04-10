part of '../../pages.dart';

class DashboardController extends GetxController {
  late final PageController pageController;

  final pakarUsernameC = TextEditingController();
  final pakarEmailC = TextEditingController();
  final pakarPasswordC = TextEditingController();
  final pakarConfirmPasswordC = TextEditingController();

  final pakarFormKey = GlobalKey<FormState>();

  final isCreatingPakar = false.obs;
  final isPakarPasswordHidden = true.obs;
  final isPakarConfirmPasswordHidden = true.obs;

  final selectedIndex = 0.obs;
  final isLoadingProfile = true.obs;

  final currentRole = Rxn<Role>();
  final username = ''.obs;
  final email = ''.obs;

  final AuthService _authService = AuthService.instance;
  final AdminService _adminService = AdminService.instance;
  final UserDashboardService _userDashboardService =
      UserDashboardService.instance;
  final PakarDashboardService _pakarDashboardService =
      PakarDashboardService.instance;

  Role get role => currentRole.value ?? Role.user;

  /// =========================
  /// ADMIN DASHBOARD
  /// =========================
  final isLoadingAdminDashboard = false.obs;

  final adminTotalUsers = 0.obs;
  final adminTotalConsultations = 0.obs;
  final adminTotalSymptoms = 0.obs;
  final adminTotalRules = 0.obs;

  final adminMonitoringItems = <DashboardActivityItem>[].obs;
  final adminConsultationSpots = <FlSpot>[].obs;
  final adminDistributionItems = <DashboardPieItem>[].obs;

  /// =========================
  /// USER DASHBOARD
  /// =========================
  final isLoadingUserDashboard = false.obs;

  final userTotalConsultations = 0.obs;
  final userMostFrequentResult = '-'.obs;
  final userRecentActivities = <DashboardActivityItem>[].obs;

  /// =========================
  /// PAKAR DASHBOARD
  /// =========================
  final isLoadingPakarDashboard = false.obs;

  final pakarTotalSymptoms = 0.obs;
  final pakarTotalRules = 0.obs;
  final pakarActiveSymptoms = 0.obs;
  final pakarInactiveSymptoms = 0.obs;
  final pakarActiveRules = 0.obs;
  final pakarInactiveRules = 0.obs;

  final pakarKnowledgeItems = <DashboardActivityItem>[].obs;
  final pakarBarChartItems = <Map<String, dynamic>>[].obs;
  final pakarPieChartItems = <DashboardPieItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    loadCurrentUserProfile();
  }

  @override
  void onClose() {
    pakarUsernameC.dispose();
    pakarEmailC.dispose();
    pakarPasswordC.dispose();
    pakarConfirmPasswordC.dispose();
    pageController.dispose();
    super.onClose();
  }

  Future<void> loadCurrentUserProfile() async {
    debugPrint('========== DASHBOARD PROFILE LOAD START ==========');

    try {
      isLoadingProfile.value = true;

      final user = _authService.currentUser;
      if (user == null) {
        debugPrint('[DASHBOARD][ERROR] currentUser NULL');
        currentRole.value = null;
        return;
      }

      debugPrint('[DASHBOARD] UID: ${user.uid}');
      debugPrint('[DASHBOARD] EMAIL AUTH: ${user.email}');

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      debugPrint('[DASHBOARD] DOC EXISTS: ${doc.exists}');
      debugPrint('[DASHBOARD] DOC DATA: ${doc.data()}');

      if (!doc.exists) {
        debugPrint('[DASHBOARD][ERROR] users/${user.uid} tidak ditemukan');
        currentRole.value = null;
        return;
      }

      final data = doc.data() ?? <String, dynamic>{};

      final roleString = (data['role'] ?? '').toString().trim().toLowerCase();
      final usernameValue = (data['username'] ?? '').toString().trim();
      final emailValue = (data['email'] ?? user.email ?? '').toString().trim();

      debugPrint('[DASHBOARD] ROLE STRING: $roleString');
      debugPrint('[DASHBOARD] USERNAME: $usernameValue');
      debugPrint('[DASHBOARD] EMAIL: $emailValue');

      currentRole.value = _mapRoleStrict(roleString);
      username.value = usernameValue;
      email.value = emailValue;
      selectedIndex.value = 0;

      await _loadDashboardByRole();

      debugPrint('[DASHBOARD] ROLE MAPPED: ${currentRole.value}');
      debugPrint('========== DASHBOARD PROFILE LOAD SUCCESS ==========');
    } catch (e, stackTrace) {
      debugPrint('[DASHBOARD][ERROR] $e');
      debugPrint('[DASHBOARD][STACKTRACE] $stackTrace');
      currentRole.value = null;
    } finally {
      isLoadingProfile.value = false;
      debugPrint('========== DASHBOARD PROFILE LOAD END ==========');
    }
  }

  Future<void> _loadDashboardByRole() async {
    switch (role) {
      case Role.user:
        await loadUserDashboard();
        break;
      case Role.pakar:
        await loadPakarDashboard();
        break;
      case Role.admin:
        await loadAdminDashboard();
        break;
    }
  }

  Future<void> loadAdminDashboard() async {
    if (role != Role.admin) return;

    debugPrint('========== LOAD ADMIN DASHBOARD START ==========');

    try {
      isLoadingAdminDashboard.value = true;

      final summary = await _adminService.getAdminDashboardSummary();

      adminTotalUsers.value = summary['totalUsers'] ?? 0;
      adminTotalConsultations.value = summary['totalConsultations'] ?? 0;
      adminTotalSymptoms.value = summary['totalSymptoms'] ?? 0;
      adminTotalRules.value = summary['totalRules'] ?? 0;

      final resultCounter =
          (summary['resultCounter'] as List<MapEntry<String, int>>?) ?? [];

      adminDistributionItems.assignAll(
        resultCounter.take(4).map((entry) {
          return DashboardPieItem(
            title: entry.key,
            value: entry.value.toDouble(),
            color: const Color(0xFF3B82F6),
          );
        }).toList(),
      );

      adminConsultationSpots.assignAll(
        resultCounter.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return FlSpot(index.toDouble(), item.value.toDouble());
        }).toList(),
      );

      adminMonitoringItems.assignAll([
        DashboardActivityItem(
          title: 'Monitoring Pengguna',
          subtitle: 'Total pengguna terdaftar: ${adminTotalUsers.value}',
          trailing: 'Users',
        ),
        DashboardActivityItem(
          title: 'Monitoring Konsultasi',
          subtitle: 'Total konsultasi masuk: ${adminTotalConsultations.value}',
          trailing: 'Data',
        ),
        DashboardActivityItem(
          title: 'Knowledge Base',
          subtitle:
              'Gejala: ${adminTotalSymptoms.value}, Rule: ${adminTotalRules.value}',
          trailing: 'KB',
        ),
      ]);

      debugPrint('[ADMIN DASHBOARD] Loaded successfully');
    } catch (e, stackTrace) {
      debugPrint('[ADMIN DASHBOARD][ERROR] $e');
      debugPrint('[ADMIN DASHBOARD][STACKTRACE] $stackTrace');
    } finally {
      isLoadingAdminDashboard.value = false;
      debugPrint('========== LOAD ADMIN DASHBOARD END ==========');
    }
  }

  Future<void> loadUserDashboard() async {
    if (role != Role.user) return;

    debugPrint('========== LOAD USER DASHBOARD START ==========');

    try {
      isLoadingUserDashboard.value = true;

      final user = _authService.currentUser;
      if (user == null) {
        debugPrint('[USER DASHBOARD][ERROR] currentUser NULL');
        return;
      }

      final summary = await _userDashboardService.getUserDashboardSummary(
        user.uid,
      );

      userTotalConsultations.value = summary['totalConsultations'] ?? 0;
      userMostFrequentResult.value = (summary['mostFrequentResult'] ?? '-')
          .toString();

      final recentActivities =
          (summary['recentActivities'] as List<dynamic>? ?? [])
              .cast<Map<String, dynamic>>();

      userRecentActivities.assignAll(
        recentActivities.map((item) {
          return DashboardActivityItem(
            title: item['title']?.toString() ?? '-',
            subtitle: item['subtitle']?.toString() ?? '-',
            trailing: item['date']?.toString() ?? '-',
          );
        }).toList(),
      );

      debugPrint('[USER DASHBOARD] Loaded successfully');
    } catch (e, stackTrace) {
      debugPrint('[USER DASHBOARD][ERROR] $e');
      debugPrint('[USER DASHBOARD][STACKTRACE] $stackTrace');
    } finally {
      isLoadingUserDashboard.value = false;
      debugPrint('========== LOAD USER DASHBOARD END ==========');
    }
  }

  Future<void> loadPakarDashboard() async {
    if (role != Role.pakar) return;

    debugPrint('========== LOAD PAKAR DASHBOARD START ==========');

    try {
      isLoadingPakarDashboard.value = true;

      final summary = await _pakarDashboardService.getPakarDashboardSummary();

      pakarTotalSymptoms.value = summary['totalSymptoms'] ?? 0;
      pakarTotalRules.value = summary['totalRules'] ?? 0;
      pakarActiveSymptoms.value = summary['activeSymptoms'] ?? 0;
      pakarInactiveSymptoms.value = summary['inactiveSymptoms'] ?? 0;
      pakarActiveRules.value = summary['activeRules'] ?? 0;
      pakarInactiveRules.value = summary['inactiveRules'] ?? 0;

      final resultCounter = (summary['resultCounter'] as List<dynamic>? ?? [])
          .cast<MapEntry<String, int>>();

      pakarBarChartItems.assignAll(
        resultCounter.take(5).map((entry) {
          return {
            'label': entry.key.length > 12
                ? '${entry.key.substring(0, 12)}...'
                : entry.key,
            'value': entry.value.toDouble(),
          };
        }).toList(),
      );

      pakarPieChartItems.assignAll([
        DashboardPieItem(
          title: 'Gejala Aktif',
          value: pakarActiveSymptoms.value.toDouble(),
          color: const Color(0xFF22C55E),
        ),
        DashboardPieItem(
          title: 'Gejala Nonaktif',
          value: pakarInactiveSymptoms.value.toDouble(),
          color: const Color(0xFFF59E0B),
        ),
        DashboardPieItem(
          title: 'Rule Aktif',
          value: pakarActiveRules.value.toDouble(),
          color: const Color(0xFF3B82F6),
        ),
        DashboardPieItem(
          title: 'Rule Nonaktif',
          value: pakarInactiveRules.value.toDouble(),
          color: const Color(0xFFEF4444),
        ),
      ]);

      final recentActivities =
          (summary['recentActivities'] as List<dynamic>? ?? [])
              .cast<Map<String, dynamic>>();

      pakarKnowledgeItems.assignAll(
        recentActivities.map((item) {
          final type = (item['type'] ?? '').toString();
          return DashboardActivityItem(
            title: item['title']?.toString() ?? '-',
            subtitle: item['subtitle']?.toString() ?? '-',
            trailing: type == 'rule' ? 'Rule' : 'Gejala',
          );
        }).toList(),
      );

      debugPrint('[PAKAR DASHBOARD] Loaded successfully');
    } catch (e, stackTrace) {
      debugPrint('[PAKAR DASHBOARD][ERROR] $e');
      debugPrint('[PAKAR DASHBOARD][STACKTRACE] $stackTrace');
    } finally {
      isLoadingPakarDashboard.value = false;
      debugPrint('========== LOAD PAKAR DASHBOARD END ==========');
    }
  }

  Role _mapRoleStrict(String role) {
    switch (role.trim().toLowerCase()) {
      case 'admin':
        return Role.admin;
      case 'pakar':
        return Role.pakar;
      case 'user':
        return Role.user;
      default:
        throw Exception('Role "$role" tidak valid di Firestore');
    }
  }

  List<DashboardMenuItem> get menuItems {
    switch (role) {
      case Role.user:
        return const [
          DashboardMenuItem(
            key: 'dashboard',
            title: 'Dashboard',
            subtitle: 'Pantau konsultasi dan akses fitur identifikasi sampah.',
            icon: Icons.dashboard_outlined,
          ),
          DashboardMenuItem(
            key: 'consultation',
            title: 'Konsultasi',
            subtitle: 'Mulai proses identifikasi sampah berdasarkan gejala.',
            icon: Icons.play_circle_outline_rounded,
          ),
          DashboardMenuItem(
            key: 'history',
            title: 'Riwayat',
            subtitle: 'Lihat hasil konsultasi dan riwayat aktivitas Anda.',
            icon: Icons.history_rounded,
          ),
        ];
      case Role.pakar:
        return const [
          DashboardMenuItem(
            key: 'dashboard',
            title: 'Dashboard',
            subtitle: 'Kelola knowledge base dan pantau rule inference system.',
            icon: Icons.dashboard_outlined,
          ),
          DashboardMenuItem(
            key: 'symptom',
            title: 'Gejala',
            subtitle: 'Kelola data gejala atau ciri sampah.',
            icon: Icons.list_alt_outlined,
          ),
          DashboardMenuItem(
            key: 'rule',
            title: 'Rule',
            subtitle: 'Kelola aturan forward chaining sistem pakar.',
            icon: Icons.rule_folder_outlined,
          ),
        ];
      case Role.admin:
        return const [
          DashboardMenuItem(
            key: 'dashboard',
            title: 'Dashboard',
            subtitle: 'Monitoring sistem, pengguna, dan laporan aplikasi.',
            icon: Icons.dashboard_outlined,
          ),
          DashboardMenuItem(
            key: 'users',
            title: 'Pengguna',
            subtitle: 'Kelola akun dan hak akses pengguna.',
            icon: Icons.group_outlined,
          ),
          DashboardMenuItem(
            key: 'report',
            title: 'Laporan',
            subtitle: 'Pantau laporan konsultasi dan performa aplikasi.',
            icon: Icons.bar_chart_outlined,
          ),
        ];
    }
  }

  String get currentMenuTitle {
    final items = menuItems;
    if (selectedIndex.value >= items.length) return items.first.title;
    return items[selectedIndex.value].title;
  }

  String get currentMenuSubtitle {
    final items = menuItems;
    if (selectedIndex.value >= items.length) return items.first.subtitle;
    return items[selectedIndex.value].subtitle;
  }

  String get profileName {
    if (username.value.isNotEmpty) return username.value;

    switch (role) {
      case Role.user:
        return 'User';
      case Role.pakar:
        return 'Pakar';
      case Role.admin:
        return 'Admin';
    }
  }

  String get initialName {
    if (username.value.isNotEmpty) {
      return username.value.characters.first.toUpperCase();
    }

    switch (role) {
      case Role.user:
        return 'U';
      case Role.pakar:
        return 'P';
      case Role.admin:
        return 'A';
    }
  }

  List<DashboardStatItem> get stats {
    switch (role) {
      case Role.user:
        return [
          DashboardStatItem(
            title: 'Total Konsultasi',
            value: '${userTotalConsultations.value}',
            icon: Icons.assignment_outlined,
            footer: 'Jumlah konsultasi yang pernah dilakukan',
          ),
          DashboardStatItem(
            title: 'Hasil Terbanyak',
            value: userMostFrequentResult.value,
            icon: Icons.eco_outlined,
            footer: 'Kategori hasil yang paling sering muncul',
          ),
          DashboardStatItem(
            title: 'Aktivitas Tersimpan',
            value: '${userRecentActivities.length}',
            icon: Icons.history_rounded,
            footer: 'Riwayat terbaru pada dashboard',
          ),
        ];

      case Role.pakar:
        return [
          DashboardStatItem(
            title: 'Total Gejala',
            value: '${pakarTotalSymptoms.value}',
            icon: Icons.list_alt_outlined,
            footer: 'Data ciri sampah terdaftar',
          ),
          DashboardStatItem(
            title: 'Total Rule',
            value: '${pakarTotalRules.value}',
            icon: Icons.rule_folder_outlined,
            footer: 'Aturan forward chaining aktif',
          ),
          DashboardStatItem(
            title: 'Rule Aktif',
            value: '${pakarActiveRules.value}',
            icon: Icons.check_circle_outline,
            footer: 'Jumlah rule berstatus aktif',
          ),
        ];

      case Role.admin:
        return [
          DashboardStatItem(
            title: 'Total Pengguna',
            value: '${adminTotalUsers.value}',
            icon: Icons.group_outlined,
            footer: 'Pengguna terdaftar dalam sistem',
          ),
          DashboardStatItem(
            title: 'Total Konsultasi',
            value: '${adminTotalConsultations.value}',
            icon: Icons.assignment_outlined,
            footer: 'Aktivitas identifikasi keseluruhan',
          ),
          DashboardStatItem(
            title: 'Knowledge Base',
            value: '${adminTotalRules.value}',
            icon: Icons.rule_folder_outlined,
            footer: 'Total rule dalam sistem',
          ),
        ];
    }
  }

  List<DashboardActivityItem> get expertKnowledge => pakarKnowledgeItems;

  List<DashboardActivityItem> get adminMonitoring => adminMonitoringItems;

  List<FlSpot> get adminConsultationTrend => adminConsultationSpots;

  List<DashboardPieItem> get adminPieSections => adminDistributionItems;

  List<Map<String, dynamic>> get expertBarData => pakarBarChartItems;

  List<DashboardPieItem> get expertPieSections => pakarPieChartItems;

  void showCreatePakarDialog() {
    clearCreatePakarForm();
    Get.dialog(
      DashboardCreatePakarDialog(controller: this),
      barrierDismissible: false,
    );
  }

  Future<void> createPakarAccount() async {
    final isValid = pakarFormKey.currentState?.validate() ?? false;
    if (!isValid) return;

    isCreatingPakar.value = true;

    try {
      final pakarUsername = pakarUsernameC.text.trim();
      final pakarEmail = pakarEmailC.text.trim();
      final pakarPassword = pakarPasswordC.text.trim();

      debugPrint('========== CREATE PAKAR START ==========');
      debugPrint('[PAKAR] username: $pakarUsername');
      debugPrint('[PAKAR] email: $pakarEmail');

      await _authService.createPakarByAdmin(
        username: pakarUsername,
        email: pakarEmail,
        password: pakarPassword,
      );

      debugPrint('[PAKAR] SUCCESS create pakar account');
      debugPrint('========== CREATE PAKAR END ==========');

      Get.back();

      Get.snackbar(
        'Berhasil',
        'Akun pakar berhasil dibuat',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('[PAKAR][FIREBASE ERROR] ${e.code}');
      debugPrint('[PAKAR][MESSAGE] ${e.message}');

      String message = 'Gagal membuat akun pakar';

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
        'Gagal',
        message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (e, stackTrace) {
      debugPrint('[PAKAR][ERROR] $e');
      debugPrint('[PAKAR][STACKTRACE] $stackTrace');

      Get.snackbar(
        'Gagal',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isCreatingPakar.value = false;
    }
  }

  String? validatePakarUsername(String? value) {
    final input = value?.trim() ?? '';

    if (input.isEmpty) {
      return 'Username wajib diisi';
    }
    if (input.length < 3) {
      return 'Username minimal 3 karakter';
    }
    if (input.contains(' ')) {
      return 'Username tidak boleh mengandung spasi';
    }
    return null;
  }

  String? validatePakarEmail(String? value) {
    final input = value?.trim() ?? '';

    if (input.isEmpty) {
      return 'Email wajib diisi';
    }
    if (!GetUtils.isEmail(input)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? validatePakarPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  String? validatePakarConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }
    if (value != pakarPasswordC.text) {
      return 'Konfirmasi password tidak sama';
    }
    return null;
  }

  void clearCreatePakarForm() {
    pakarUsernameC.clear();
    pakarEmailC.clear();
    pakarPasswordC.clear();
    pakarConfirmPasswordC.clear();
    isPakarPasswordHidden.value = true;
    isPakarConfirmPasswordHidden.value = true;
    pakarFormKey.currentState?.reset();
  }

  void togglePakarPasswordVisibility() {
    isPakarPasswordHidden.toggle();
  }

  void togglePakarConfirmPasswordVisibility() {
    isPakarConfirmPasswordHidden.toggle();
  }

  void changePage(int index) {
    if (index < 0 || index >= menuItems.length) return;
    if (selectedIndex.value == index) return;

    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
    );
  }

  void goToConsultation() {
    if (role == Role.user && menuItems.length > 1) {
      changePage(1);
    }
  }

  void goToHistory() {
    if (role == Role.user && menuItems.length > 2) {
      changePage(2);
    }
  }

  void onPageChanged(int index) {
    if (index >= 0 && index < menuItems.length) {
      selectedIndex.value = index;
    }
  }

  void logout() {
    _authService.signOut().whenComplete(() {
      Get.offAll(() => const Login());
    });
  }
}
