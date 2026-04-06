part of '../../pages.dart';

class ReportsController extends GetxController {
  final searchC = TextEditingController();
  final isLoading = false.obs;
  final currentPage = 1.obs;
  final pageSize = 5;

  final reports = <ReportItem>[
    const ReportItem(
      date: '2026-04-01',
      category: 'Organik',
      total: '80',
      trend: '+8%',
    ),
    const ReportItem(
      date: '2026-03-28',
      category: 'Anorganik',
      total: '62',
      trend: '+4%',
    ),
    const ReportItem(
      date: '2026-03-24',
      category: 'B3',
      total: '21',
      trend: '+2%',
    ),
    const ReportItem(
      date: '2026-03-20',
      category: 'Kertas',
      total: '40',
      trend: '+3%',
    ),
    const ReportItem(
      date: '2026-03-16',
      category: 'Logam',
      total: '18',
      trend: '+1%',
    ),
    const ReportItem(
      date: '2026-03-10',
      category: 'Organik',
      total: '73',
      trend: '+5%',
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 700));
    isLoading.value = false;
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
    final end = (start + pageSize) > data.length ? data.length : start + pageSize;
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