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

  @override
  void onInit() {
    super.onInit();
    _seedData();
    loadInitialData();
    searchC.addListener(_onSearchChanged);
  }

  void _seedData() {
    items.assignAll(const [
      RuleItemModel(
        id: 1,
        condition: 'Basah AND Mudah membusuk',
        result: 'Sampah Organik',
        status: 'Aktif',
      ),
      RuleItemModel(
        id: 2,
        condition: 'Kering AND Plastik',
        result: 'Sampah Anorganik',
        status: 'Aktif',
      ),
      RuleItemModel(
        id: 3,
        condition: 'Beracun AND Bahan kimia',
        result: 'Sampah B3',
        status: 'Aktif',
      ),
      RuleItemModel(
        id: 4,
        condition: 'Kertas AND Kering',
        result: 'Sampah Daur Ulang',
        status: 'Aktif',
      ),
      RuleItemModel(
        id: 5,
        condition: 'Daun AND Basah',
        result: 'Sampah Organik',
        status: 'Aktif',
      ),
      RuleItemModel(
        id: 6,
        condition: 'Botol kaca AND Keras',
        result: 'Sampah Anorganik',
        status: 'Nonaktif',
      ),
    ]);
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 700));
    isLoading.value = false;
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

    isSubmitting.value = true;

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      final nextId = items.isEmpty
          ? 1
          : items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

      items.add(
        RuleItemModel(
          id: nextId,
          condition: conditionC.text.trim(),
          result: resultC.text.trim(),
          status: selectedStatus.value,
        ),
      );

      Get.back();
      Get.snackbar(
        'Berhasil',
        'Rule berhasil ditambahkan.',
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
      await Future.delayed(const Duration(milliseconds: 400));

      final index = items.indexWhere((e) => e.id == item.id);
      if (index == -1) return;

      items[index] = item.copyWith(
        condition: conditionC.text.trim(),
        result: resultC.text.trim(),
        status: selectedStatus.value,
      );
      items.refresh();

      Get.back();
      Get.snackbar(
        'Berhasil',
        'Rule berhasil diperbarui.',
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
            onPressed: () {
              items.removeWhere((e) => e.id == item.id);

              if (currentPage.value > totalPages) {
                currentPage.value = totalPages;
              }

              Get.back();
              Get.snackbar(
                'Berhasil',
                'Rule berhasil dihapus.',
                snackPosition: SnackPosition.BOTTOM,
              );
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
