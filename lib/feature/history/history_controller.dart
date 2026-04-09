part of '../../pages.dart';

class HistoryController extends GetxController {
  final searchC = TextEditingController();
  final isLoading = false.obs;
  final currentPage = 1.obs;
  final pageSize = 5;

  final histories = <HistoryItem>[].obs;

  final ConsultationService _service = ConsultationService.instance;
  final AuthService _authService = AuthService.instance;

  StreamSubscription<List<Map<String, dynamic>>>? _historySubscription;

  @override
  void onInit() {
    super.onInit();
    debugPrint('========== HISTORY CONTROLLER INIT ==========');
    listenHistory();
  }

  Future<void> listenHistory() async {
    debugPrint('========== LISTEN HISTORY START ==========');

    try {
      isLoading.value = true;

      final user = _authService.currentUser;
      debugPrint('[HISTORY] currentUser = ${user?.uid}');
      debugPrint('[HISTORY] currentUser email = ${user?.email}');

      if (user == null) {
        debugPrint('[HISTORY][ERROR] User login tidak ditemukan');
        isLoading.value = false;
        return;
      }

      await _historySubscription?.cancel();

      _historySubscription = _service.streamUserHistory(user.uid).listen(
            (data) {
          debugPrint('[HISTORY][STREAM] total data = ${data.length}');
          debugPrint('[HISTORY][STREAM] raw data = $data');

          histories.assignAll(
            data.map((e) {
              final timestamp = e['createdAt'] as Timestamp?;
              final date = timestamp != null
                  ? timestamp.toDate().toString().split(' ')[0]
                  : '-';

              return HistoryItem(
                date: date,
                result: (e['result'] ?? '-').toString(),
                recommendation: (e['recommendation'] ?? '-').toString(),
                status: 'Selesai',
              );
            }).toList(),
          );

          if (currentPage.value > totalPages) {
            currentPage.value = totalPages;
          }

          isLoading.value = false;
          debugPrint('[HISTORY][STREAM] histories assigned = ${histories.length}');
        },
        onError: (error, stackTrace) {
          debugPrint('[HISTORY][STREAM ERROR] $error');
          debugPrint('[HISTORY][STREAM STACKTRACE] $stackTrace');
          isLoading.value = false;

          Get.snackbar(
            'Error',
            'Gagal memantau history realtime',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('[HISTORY][ERROR] $e');
      debugPrint('[HISTORY][STACKTRACE] $stackTrace');
      isLoading.value = false;
    } finally {
      debugPrint('========== LISTEN HISTORY END ==========');
    }
  }

  List<HistoryItem> get filteredItems {
    final keyword = searchC.text.toLowerCase().trim();

    if (keyword.isEmpty) return histories;

    return histories.where((item) {
      return item.result.toLowerCase().contains(keyword) ||
          item.recommendation.toLowerCase().contains(keyword) ||
          item.date.toLowerCase().contains(keyword);
    }).toList();
  }

  int get totalPages {
    final total = (filteredItems.length / pageSize).ceil();
    return total < 1 ? 1 : total;
  }

  List<HistoryItem> get paginatedItems {
    final data = filteredItems;
    final start = (currentPage.value - 1) * pageSize;

    if (start >= data.length) return [];

    final end = (start + pageSize).clamp(0, data.length);
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
    debugPrint('========== HISTORY CONTROLLER CLOSE ==========');
    _historySubscription?.cancel();
    searchC.dispose();
    super.onClose();
  }
}