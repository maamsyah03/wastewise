part of '../../pages.dart';

class HistoryController extends GetxController {
  final searchC = TextEditingController();
  final isLoading = false.obs;
  final currentPage = 1.obs;
  final pageSize = 5;

  final histories = <HistoryItem>[
    const HistoryItem(
      date: '2026-03-24',
      result: 'Sampah Organik',
      recommendation: 'Pisahkan dari plastik',
      status: 'Selesai',
    ),
    const HistoryItem(
      date: '2026-03-20',
      result: 'Sampah Kertas',
      recommendation: 'Simpan untuk daur ulang',
      status: 'Selesai',
    ),
    const HistoryItem(
      date: '2026-03-16',
      result: 'Sampah Logam',
      recommendation: 'Pisahkan ke bank sampah',
      status: 'Selesai',
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

  List<HistoryItem> get filteredItems {
    final keyword = searchC.text.trim().toLowerCase();
    if (keyword.isEmpty) return histories;

    return histories.where((item) {
      return item.result.toLowerCase().contains(keyword) ||
          item.recommendation.toLowerCase().contains(keyword) ||
          item.date.toLowerCase().contains(keyword);
    }).toList();
  }

  int get totalPages {
    final total = filteredItems.length;
    if (total == 0) return 1;
    return (total / pageSize).ceil();
  }

  List<HistoryItem> get paginatedItems {
    final data = filteredItems;
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