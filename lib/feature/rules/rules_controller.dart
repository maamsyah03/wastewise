part of '../../pages.dart';

class RulesController extends GetxController {
  final searchC = TextEditingController();
  final conditionC = TextEditingController();
  final resultC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final currentPage = 1.obs;
  final selectedStatus = 'Aktif'.obs;

  final int pageSize = 5;
  final items = <RuleItemModel>[].obs;
  final List<String> statusOptions = const ['Aktif', 'Nonaktif'];

  final RuleService _ruleService = RuleService.instance;
  final AuthService _authService = AuthService.instance;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
    searchC.addListener(_onSearchChanged);
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;

    try {
      final results = await _ruleService.getRules();

      items.assignAll(
        results.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final docId = (data['docId'] ?? '').toString();

          return RuleItemModel.fromFirestore(
            docId: docId,
            index: index,
            data: data,
          );
        }).toList(),
      );
    } catch (e, stackTrace) {
      debugPrint('[RULES][LOAD ERROR] $e');
      debugPrint('[RULES][STACKTRACE] $stackTrace');

      Get.snackbar(
        'Gagal',
        'Data rule gagal dimuat.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _onSearchChanged() {
    resetPage();
  }

  List<RuleItemModel> get filteredItems {
    final keyword = searchC.text.trim().toLowerCase();

    if (keyword.isEmpty) return items;

    return items.where((item) {
      return item.condition.toLowerCase().contains(keyword) ||
          item.result.toLowerCase().contains(keyword) ||
          item.status.toLowerCase().contains(keyword);
    }).toList();
  }

  bool get hasData => filteredItems.isNotEmpty;

  int get totalPages {
    final total = filteredItems.length;
    if (total == 0) return 1;
    return (total / pageSize).ceil();
  }

  List<RuleItemModel> get paginatedItems {
    final data = filteredItems;
    final start = (currentPage.value - 1) * pageSize;

    if (start >= data.length) return [];

    final end = (start + pageSize > data.length)
        ? data.length
        : start + pageSize;

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

  void setStatus(String? value) {
    if (value != null) selectedStatus.value = value;
  }

  void clearForm() {
    formKey.currentState?.reset();
    conditionC.clear();
    resultC.clear();
    selectedStatus.value = 'Aktif';
  }

  String? validateCondition(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Kondisi rule wajib diisi';
    }
    if (value.trim().length < 3) {
      return 'Kondisi rule minimal 3 karakter';
    }
    return null;
  }

  String? validateResult(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Hasil rule wajib diisi';
    }
    if (value.trim().length < 3) {
      return 'Hasil rule minimal 3 karakter';
    }
    return null;
  }

  Widget _buildFormBody() {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFieldCustom(
            hintText: 'Masukkan kondisi rule',
            lebel: 'Kondisi Rule',
            controller: conditionC,
            validator: validateCondition,
            cursorHeight: 20,
            cursorColor: Colors.black87,
            fillColor: const Color(0xFFF8FAFC),
            hintColor: Colors.grey,
            borderRadius: 16,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorderSide: const BorderSide(color: Color(0xFFD0D5DD)),
            focusedBorderSide: const BorderSide(
              color: Color(0xFF0F5EF7),
              width: 1.4,
            ),
            errorBorderSide: const BorderSide(color: Colors.red),
          ),
          const SizedBox(height: 14),
          TextFieldCustom(
            hintText: 'Masukkan hasil rule',
            lebel: 'Hasil Rule',
            controller: resultC,
            validator: validateResult,
            cursorHeight: 20,
            cursorColor: Colors.black87,
            fillColor: const Color(0xFFF8FAFC),
            hintColor: Colors.grey,
            borderRadius: 16,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorderSide: const BorderSide(color: Color(0xFFD0D5DD)),
            focusedBorderSide: const BorderSide(
              color: Color(0xFF0F5EF7),
              width: 1.4,
            ),
            errorBorderSide: const BorderSide(color: Colors.red),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            value: selectedStatus.value,
            items: statusOptions
                .map(
                  (status) =>
                      DropdownMenuItem(value: status, child: Text(status)),
                )
                .toList(),
            onChanged: setStatus,
            decoration: InputDecoration(
              labelText: 'Status',
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openAddDialog() {
    clearForm();

    Get.dialog(
      Obx(
        () => FormDialog(
          title: 'Tambah Rule',
          subtitle: 'Lengkapi data rule forward chaining.',
          submitLabel: 'Simpan',
          formKey: formKey,
          isSubmitting: isSubmitting.value,
          onSubmit: addItem,
          child: _buildFormBody(),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void openEditDialog(RuleItemModel item) {
    conditionC.text = item.condition;
    resultC.text = item.result;
    selectedStatus.value = item.status;

    Get.dialog(
      Obx(
        () => FormDialog(
          title: 'Edit Rule',
          subtitle: 'Perbarui data rule forward chaining.',
          submitLabel: 'Update',
          formKey: formKey,
          isSubmitting: isSubmitting.value,
          onSubmit: () => updateItem(item),
          child: _buildFormBody(),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> addItem() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      Get.snackbar(
        'Gagal',
        'User login tidak ditemukan.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSubmitting.value = true;

    try {
      await _ruleService.createRule(
        condition: conditionC.text.trim(),
        result: resultC.text.trim(),
        status: selectedStatus.value,
        createdBy: currentUser.uid,
      );

      await loadInitialData();
      clearForm();
      Get.back();

      Get.snackbar(
        'Berhasil',
        'Rule berhasil ditambahkan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      debugPrint('[RULES][ADD ERROR] $e');
      debugPrint('[RULES][STACKTRACE] $stackTrace');

      Get.snackbar(
        'Gagal',
        'Rule gagal ditambahkan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> updateItem(RuleItemModel item) async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    isSubmitting.value = true;

    try {
      await _ruleService.updateRule(
        docId: item.docId,
        condition: conditionC.text.trim(),
        result: resultC.text.trim(),
        status: selectedStatus.value,
      );

      await loadInitialData();
      Get.back();

      Get.snackbar(
        'Berhasil',
        'Rule berhasil diperbarui.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      debugPrint('[RULES][UPDATE ERROR] $e');
      debugPrint('[RULES][STACKTRACE] $stackTrace');

      Get.snackbar(
        'Gagal',
        'Rule gagal diperbarui.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void deleteItem(RuleItemModel item) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Rule'),
        content: Text('Yakin ingin menghapus rule "${item.result}"?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _ruleService.deleteRule(item.docId);
                await loadInitialData();

                if (currentPage.value > totalPages) {
                  currentPage.value = totalPages;
                }

                Get.back();
                Get.snackbar(
                  'Berhasil',
                  'Rule berhasil dihapus.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              } catch (e, stackTrace) {
                debugPrint('[RULES][DELETE ERROR] $e');
                debugPrint('[RULES][STACKTRACE] $stackTrace');

                Get.back();
                Get.snackbar(
                  'Gagal',
                  'Rule gagal dihapus.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    searchC.removeListener(_onSearchChanged);
    searchC.dispose();
    conditionC.dispose();
    resultC.dispose();
    super.onClose();
  }
}
