part of '../../pages.dart';

class ReportsController extends GetxController {
  final searchC = TextEditingController();
  final isLoading = false.obs;
  final currentPage = 1.obs;
  final pageSize = 5;

  final reports = <ReportItem>[].obs;

  final AdminService _adminService = AdminService.instance;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    debugPrint('========== LOAD REPORTS START ==========');

    try {
      isLoading.value = true;

      final data = await _adminService.getConsultations();

      final Map<String, int> grouped = {};

      for (final item in data) {
        final category = (item['result'] ?? 'Tidak diketahui').toString();
        grouped[category] = (grouped[category] ?? 0) + 1;
      }

      final now = DateTime.now().toString().split(' ')[0];

      reports.assignAll(
        grouped.entries.map((e) {
          return ReportItem(
            date: now,
            category: e.key,
            total: e.value.toString(),
            trend: '-',
          );
        }).toList(),
      );

      debugPrint('[REPORTS] total loaded = ${reports.length}');
    } catch (e, stackTrace) {
      debugPrint('[REPORTS][ERROR] $e');
      debugPrint('[REPORTS][STACKTRACE] $stackTrace');

      Get.snackbar(
        'Gagal',
        'Laporan gagal dimuat.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      debugPrint('========== LOAD REPORTS END ==========');
    }
  }

  List<ReportItem> get filteredReports {
    final keyword = searchC.text.trim().toLowerCase();
    if (keyword.isEmpty) return reports;

    return reports.where((item) {
      return item.date.toLowerCase().contains(keyword) ||
          item.category.toLowerCase().contains(keyword) ||
          item.total.toLowerCase().contains(keyword) ||
          item.trend.toLowerCase().contains(keyword);
    }).toList();
  }

  int get totalPages {
    final total = filteredReports.length;
    if (total == 0) return 1;
    return (total / pageSize).ceil();
  }

  List<ReportItem> get paginatedReports {
    final data = filteredReports;
    final start = (currentPage.value - 1) * pageSize;
    final end = (start + pageSize) > data.length
        ? data.length
        : start + pageSize;
    if (start >= data.length) return [];
    return data.sublist(start, end);
  }

  void nextPage() {
    if (currentPage.value < totalPages) currentPage.value++;
  }

  void prevPage() {
    if (currentPage.value > 1) currentPage.value--;
  }

  void resetPage() {
    currentPage.value = 1;
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}
