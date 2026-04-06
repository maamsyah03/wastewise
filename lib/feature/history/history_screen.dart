part of '../../pages.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final HistoryController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<HistoryController>()
        ? Get.find<HistoryController>()
        : Get.put(HistoryController());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.paginatedItems;
      final hasSearch = controller.searchC.text.trim().isNotEmpty;
      final totalFiltered = controller.filteredItems.length;

      return SingleChildScrollView(
        child: DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardSectionTitle(
                title: 'Riwayat Konsultasi',
                subtitle:
                'Lihat hasil identifikasi yang pernah dilakukan beserta rekomendasi pengelolaannya.',
              ),
              const SizedBox(height: 20),

              _buildSearchField(),
              const SizedBox(height: 16),

              if (!controller.isLoading.value && controller.filteredItems.isNotEmpty)
                _HistorySummarySection(
                  totalData: totalFiltered,
                  currentPage: controller.currentPage.value,
                  totalPages: controller.totalPages,
                  hasSearch: hasSearch,
                ),

              const SizedBox(height: 20),

              if (controller.isLoading.value)
                const CircularIndicator()
              else if (controller.filteredItems.isEmpty)
                EmptyState(
                  icon: hasSearch
                      ? Icons.search_off_rounded
                      : Icons.history_toggle_off_rounded,
                  title: hasSearch
                      ? 'Riwayat tidak ditemukan'
                      : 'Belum ada riwayat',
                  subtitle: hasSearch
                      ? 'Coba gunakan kata kunci lain untuk menemukan riwayat konsultasi.'
                      : 'Hasil konsultasi Anda akan muncul di sini setelah proses identifikasi dilakukan.',
                  buttonLabel: hasSearch ? 'Reset Pencarian' : null,
                  onPressed: hasSearch
                      ? () {
                    controller.searchC.clear();
                    controller.resetPage();
                  }
                      : null,
                )
              else ...[
                  ...items.map(
                        (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _HistoryItemCard(item: item),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Pagination(
                    currentPage: controller.currentPage.value,
                    totalPages: controller.totalPages,
                    onPrev: controller.prevPage,
                    onNext: controller.nextPage,
                  ),
                ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSearchField() {
    return TextFieldCustom(
      hintText: 'Cari hasil, rekomendasi, atau tanggal...',
      lebel: '',
      controller: controller.searchC,
      cursorHeight: 20,
      cursorColor: Colors.black87,
      fillColor: const Color(0xFFF8FAFC),
      hintColor: Colors.grey,
      borderRadius: 16,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      prefixIcon: const Icon(
        Icons.search,
        color: Color(0xFF667085),
        size: 20,
      ),
      suffixIcon: controller.searchC.text.trim().isEmpty
          ? null
          : IconButton(
        onPressed: () {
          controller.searchC.clear();
          controller.resetPage();
        },
        icon: const Icon(
          Icons.close_rounded,
          size: 20,
          color: Color(0xFF667085),
        ),
      ),
      enabledBorderSide: const BorderSide(color: Color(0xFFD0D5DD)),
      focusedBorderSide: const BorderSide(
        color: Color(0xFF0F5EF7),
        width: 1.4,
      ),
      errorBorderSide: const BorderSide(color: Colors.red),
      onChanged: (_) => controller.resetPage(),
    );
  }
}

class _HistorySummarySection extends StatelessWidget {
  final int totalData;
  final int currentPage;
  final int totalPages;
  final bool hasSearch;

  const _HistorySummarySection({
    required this.totalData,
    required this.currentPage,
    required this.totalPages,
    required this.hasSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _SummaryBadge(
          icon: Icons.folder_open_outlined,
          label: '$totalData data',
        ),
        _SummaryBadge(
          icon: Icons.layers_outlined,
          label: 'Halaman $currentPage dari $totalPages',
        ),
        if (hasSearch)
          const _SummaryBadge(
            icon: Icons.filter_alt_outlined,
            label: 'Pencarian aktif',
          ),
      ],
    );
  }
}

class _SummaryBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SummaryBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF667085)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF344054),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryItemCard extends StatelessWidget {
  final HistoryItem item;

  const _HistoryItemCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: Color(0xFF155EEF),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.result,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF101828),
                  ),
                ),
              ),
              _HistoryStatusBadge(status: item.status),
            ],
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HistoryMetaChip(
                icon: Icons.calendar_today_outlined,
                label: item.date,
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE4E7EC)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rekomendasi Pengelolaan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF344054),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.recommendation,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF667085),
                    height: 1.6,
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

class _HistoryMetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HistoryMetaChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF667085)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF344054),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryStatusBadge extends StatelessWidget {
  final String status;

  const _HistoryStatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();

    final bool isSuccess =
        normalized.contains('selesai') ||
            normalized.contains('berhasil') ||
            normalized.contains('success');

    final Color bgColor = isSuccess
        ? const Color(0xFFECFDF3)
        : const Color(0xFFFFFAEB);

    final Color textColor = isSuccess
        ? const Color(0xFF027A48)
        : const Color(0xFFB54708);

    final Color borderColor = isSuccess
        ? const Color(0xFFABEFC6)
        : const Color(0xFFFEDF89);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}