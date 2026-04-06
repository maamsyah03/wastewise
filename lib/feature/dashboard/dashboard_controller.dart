part of '../../pages.dart';

class DashboardController extends GetxController {
  final Role role;

  DashboardController({required this.role});

  late final PageController pageController;
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
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

  String get currentMenuTitle => menuItems[selectedIndex.value].title;

  String get currentMenuSubtitle => menuItems[selectedIndex.value].subtitle;

  String get profileName {
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
        return const [
          DashboardStatItem(
            title: 'Total Konsultasi',
            value: '18',
            icon: Icons.assignment_outlined,
            footer: 'Riwayat identifikasi pengguna',
          ),
          DashboardStatItem(
            title: 'Hasil Organik',
            value: '10',
            icon: Icons.eco_outlined,
            footer: 'Jenis sampah paling sering muncul',
          ),
          DashboardStatItem(
            title: 'Rekomendasi Tersimpan',
            value: '7',
            icon: Icons.bookmark_border_rounded,
            footer: 'Panduan yang pernah disimpan',
          ),
        ];
      case Role.pakar:
        return const [
          DashboardStatItem(
            title: 'Total Gejala',
            value: '24',
            icon: Icons.list_alt_outlined,
            footer: 'Data ciri sampah terdaftar',
          ),
          DashboardStatItem(
            title: 'Total Rule',
            value: '16',
            icon: Icons.rule_folder_outlined,
            footer: 'Aturan forward chaining aktif',
          ),
          DashboardStatItem(
            title: 'Jenis Sampah',
            value: '8',
            icon: Icons.recycling_outlined,
            footer: 'Kategori sampah dalam knowledge base',
          ),
        ];
      case Role.admin:
        return const [
          DashboardStatItem(
            title: 'Total Pengguna',
            value: '128',
            icon: Icons.group_outlined,
            footer: 'Pengguna terdaftar dalam sistem',
          ),
          DashboardStatItem(
            title: 'Total Konsultasi',
            value: '356',
            icon: Icons.assignment_outlined,
            footer: 'Aktivitas identifikasi keseluruhan',
          ),
          DashboardStatItem(
            title: 'Sistem Aktif',
            value: '99%',
            icon: Icons.monitor_heart_outlined,
            footer: 'Status operasional aplikasi',
          ),
        ];
    }
  }

  List<DashboardActivityItem> get expertKnowledge => const [
    DashboardActivityItem(
      title: 'Gejala Baru Ditambahkan',
      subtitle: 'Data gejala “mudah terurai” masuk ke knowledge base',
      trailing: 'Baru',
    ),
    DashboardActivityItem(
      title: 'Rule Diperbarui',
      subtitle: 'Aturan inferensi untuk sampah anorganik telah disesuaikan',
      trailing: '2 update',
    ),
    DashboardActivityItem(
      title: 'Validasi Jenis Sampah',
      subtitle: 'Pakar sedang meninjau konsistensi kategori dan rekomendasi',
      trailing: 'Review',
    ),
  ];

  List<DashboardActivityItem> get adminMonitoring => const [
    DashboardActivityItem(
      title: 'Aktivitas Pengguna',
      subtitle: 'Sebagian besar aktivitas berasal dari menu konsultasi',
      trailing: 'Normal',
    ),
    DashboardActivityItem(
      title: 'Laporan Sistem',
      subtitle:
          'Tidak ada gangguan besar pada modul dashboard dan identifikasi',
      trailing: 'Stabil',
    ),
    DashboardActivityItem(
      title: 'Data Konsultasi',
      subtitle: 'Jumlah konsultasi meningkat dibanding periode sebelumnya',
      trailing: '+12%',
    ),
  ];

  List<FlSpot> get adminConsultationTrend => const [
    FlSpot(0, 12),
    FlSpot(1, 18),
    FlSpot(2, 15),
    FlSpot(3, 21),
    FlSpot(4, 24),
    FlSpot(5, 19),
    FlSpot(6, 27),
  ];

  List<DashboardPieItem> get adminPieSections => const [
    DashboardPieItem(title: 'Organik', value: 40, color: Color(0xFF22C55E)),
    DashboardPieItem(title: 'Anorganik', value: 35, color: Color(0xFF3B82F6)),
    DashboardPieItem(title: 'B3', value: 15, color: Color(0xFFF59E0B)),
    DashboardPieItem(title: 'Lainnya', value: 10, color: Color(0xFFEF4444)),
  ];

  List<Map<String, dynamic>> get expertBarData => const [
    {'label': 'Rule 1', 'value': 12.0},
    {'label': 'Rule 2', 'value': 18.0},
    {'label': 'Rule 3', 'value': 9.0},
    {'label': 'Rule 4', 'value': 15.0},
    {'label': 'Rule 5', 'value': 11.0},
  ];

  List<DashboardPieItem> get expertPieSections => const [
    DashboardPieItem(title: 'Organik', value: 45, color: Color(0xFF22C55E)),
    DashboardPieItem(title: 'Anorganik', value: 30, color: Color(0xFF3B82F6)),
    DashboardPieItem(title: 'B3', value: 25, color: Color(0xFFF59E0B)),
  ];

  void changePage(int index) {
    if (selectedIndex.value == index) return;
    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
    );
  }

  void goToConsultation() {
    if (role != Role.user) return;
    changePage(1);
  }

  void goToHistory() {
    if (role != Role.user) return;
    changePage(2);
  }

  void onPageChanged(int index) {
    selectedIndex.value = index;
  }

  void logout() {
    Get.offAll(() => const Login());
  }
}
