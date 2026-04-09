part of '../../pages.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final DashboardController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<DashboardController>()
        ? Get.find<DashboardController>()
        : Get.put(DashboardController());
  }

  @override
  void dispose() {
    if (Get.isRegistered<DashboardController>()) {
      Get.delete<DashboardController>();
    }
    super.dispose();
  }

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 760;

  bool _isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 760 && width < 1100;
  }

  int _gridCount(BuildContext context) {
    if (_isMobile(context)) return 1;
    if (_isTablet(context)) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    return Obx(() {
      if (controller.isLoadingProfile.value) {
        return const Scaffold(
          backgroundColor: Color(0xFFF6F8FC),
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.currentRole.value == null) {
        return Scaffold(
          backgroundColor: const Color(0xFFF6F8FC),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 56,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Role user tidak ditemukan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pastikan document users di Firestore memiliki field role yang valid.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.logout,
                    child: const Text('Kembali ke Login'),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return Scaffold(
        backgroundColor: const Color(0xFFF6F8FC),
        appBar: isMobile
            ? AppBar(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 0,
                title: Text(
                  controller.currentMenuTitle,
                  style: const TextStyle(
                    color: Color(0xFF101828),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                iconTheme: const IconThemeData(color: Color(0xFF101828)),
              )
            : null,
        drawer: isMobile ? Drawer(child: _buildSidebar()) : null,
        body: SafeArea(
          child: Row(
            children: [
              if (!isMobile) SizedBox(width: 280, child: _buildSidebar()),
              Expanded(child: _buildContent(context)),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSidebar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogoSection(),
          const SizedBox(height: 24),
          Expanded(
            child: Obx(() {
              final selectedIndex = controller.selectedIndex.value;
              final menuItems = controller.menuItems;

              return ListView.separated(
                itemCount: menuItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  final selected = selectedIndex == index;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        controller.changePage(index);
                        if (_isMobile(context)) Get.back();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFFEFF4FF)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFFB2CCFF)
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              color: selected
                                  ? const Color(0xFF155EEF)
                                  : const Color(0xFF667085),
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? const Color(0xFF155EEF)
                                      : const Color(0xFF344054),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          if (controller.role == Role.admin) ...[
            const SizedBox(height: 14),
            DashboardCreatePakarShortcut(
              onTap: controller.showCreatePakarDialog,
            ),
          ],
          const SizedBox(height: 12),
          _buildProfileSection(),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: const Row(
        children: [
          Icon(Icons.eco_rounded, color: Color(0xFF155EEF)),
          SizedBox(width: 10),
          Text(
            'WasteWise',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: Color(0xFF101828),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE4E7EC)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFEFF4FF),
              child: Text(
                controller.initialName,
                style: const TextStyle(
                  color: Color(0xFF155EEF),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(capitalize(controller.profileName),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF101828),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_isMobile(context) ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => _buildHeader(
              context,
              title: controller.currentMenuTitle,
              subtitle: controller.currentMenuSubtitle,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              children: [
                _buildDashboardHomePage(context),
                ..._buildRolePages(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF101828),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        if (!_isMobile(context))
          DashboardHeaderButton(icon: Icons.logout, onTap: controller.logout),
      ],
    );
  }

  Widget _buildDashboardHomePage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildStatsSection(context),
          const SizedBox(height: 20),
          _buildMainSection(),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final stats = controller.stats;
    final crossAxisCount = _gridCount(context);

    return GridView.builder(
      itemCount: stats.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: _isMobile(context) ? 1.7 : 1.45,
      ),
      itemBuilder: (_, index) {
        final item = stats[index];
        return DashboardStatCard(item: item);
      },
    );
  }

  Widget _buildMainSection() {
    switch (controller.role) {
      case Role.user:
        if (controller.isLoadingUserDashboard.value) {
          return const DashboardCard(
            child: SizedBox(
              height: 180,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        return Column(
          children: [
            DashboardCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardSectionTitle(
                    title: 'Mulai Konsultasi',
                    subtitle:
                        'Gunakan fitur konsultasi untuk mengidentifikasi jenis sampah dan mendapatkan rekomendasi pengelolaan.',
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ActionButton(
                        label: 'Mulai Konsultasi',
                        icon: Icons.play_circle_outline_rounded,
                        onTap: controller.goToConsultation,
                      ),
                      ActionButton(
                        label: 'Lihat Riwayat',
                        icon: Icons.history_rounded,
                        onTap: controller.goToHistory,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            DashboardCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardSectionTitle(
                    title: 'Aktivitas Terbaru',
                    subtitle: 'Ringkasan hasil konsultasi terbaru Anda.',
                  ),
                  const SizedBox(height: 16),
                  if (controller.userRecentActivities.isEmpty)
                    const Text('Belum ada riwayat konsultasi.')
                  else
                    ...controller.userRecentActivities.map(
                      (item) => DashboardActivityTile(item: item),
                    ),
                ],
              ),
            ),
          ],
        );

      case Role.pakar:
        if (controller.isLoadingPakarDashboard.value) {
          return const DashboardCard(
            child: SizedBox(
              height: 180,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        return Column(
          children: [
            DashboardCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardSectionTitle(
                    title: 'Analisis Rule Pakar',
                    subtitle:
                        'Visualisasi hasil rule yang paling sering digunakan.',
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 260,
                    child: ExpertBarChart(items: controller.expertBarData),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            DashboardCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardSectionTitle(
                    title: 'Distribusi Knowledge Base',
                    subtitle: 'Komposisi gejala dan rule aktif/nonaktif.',
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 260,
                    child: ExpertPieChart(items: controller.expertPieSections),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            DashboardCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardSectionTitle(
                    title: 'Aktivitas Terbaru',
                    subtitle: 'Perubahan terbaru pada gejala dan rule sistem.',
                  ),
                  const SizedBox(height: 16),
                  if (controller.expertKnowledge.isEmpty)
                    const Text('Belum ada aktivitas terbaru.')
                  else
                    ...controller.expertKnowledge.map(
                      (item) => DashboardActivityTile(item: item),
                    ),
                ],
              ),
            ),
          ],
        );

      case Role.admin:
        if (controller.isLoadingAdminDashboard.value) {
          return const DashboardCard(
            child: SizedBox(
              height: 180,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        return Column(
          children: [
            DashboardCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardSectionTitle(
                    title: 'Tren Konsultasi',
                    subtitle:
                        'Pergerakan jumlah konsultasi dalam 7 periode terakhir.',
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 280,
                    child: AdminLineChart(
                      spots: controller.adminConsultationTrend,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            DashboardCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardSectionTitle(
                    title: 'Distribusi Jenis Sampah',
                    subtitle:
                        'Komposisi hasil konsultasi berdasarkan kategori.',
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 280,
                    child: AdminPieChart(items: controller.adminPieSections),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            DashboardCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardSectionTitle(
                    title: 'Monitoring Sistem',
                    subtitle: 'Pantau aktivitas pengguna dan performa sistem.',
                  ),
                  const SizedBox(height: 16),
                  ...controller.adminMonitoring.map(
                    (item) => DashboardActivityTile(item: item),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }

  List<Widget> _buildRolePages() {
    switch (controller.role) {
      case Role.user:
        return const [ConsultationScreen(), HistoryScreen()];
      case Role.pakar:
        return const [SymptomsScreen(), RulesScreen()];
      case Role.admin:
        return const [UsersScreen(), ReportsScreen()];
    }
  }
}
