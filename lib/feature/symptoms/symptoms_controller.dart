part of '../../pages.dart';

class SymptomsController extends GetxController {
  final searchC = TextEditingController();
  final symptomC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final currentPage = 1.obs;
  final selectedStatus = 'Aktif'.obs;

  final int pageSize = 5;
  final items = <SymptomItem>[].obs;
  final List<String> statusOptions = const ['Aktif', 'Nonaktif'];

  final SymptomService _symptomService = SymptomService.instance;
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
      final results = await _symptomService.getSymptoms();

      items.assignAll(
        results.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final docId = (data['docId'] ?? '').toString();

          return SymptomItem.fromFirestore(
            docId: docId,
            index: index,
            data: data,
          );
        }).toList(),
      );
    } catch (e, stackTrace) {
      debugPrint('[SYMPTOMS][LOAD ERROR] $e');
      debugPrint('[SYMPTOMS][STACKTRACE] $stackTrace');

      Get.snackbar(
        'Gagal',
        'Data gejala gagal dimuat.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _onSearchChanged() {
    currentPage.value = 1;
  }

  List<SymptomItem> get filteredItems {
    final keyword = searchC.text.trim().toLowerCase();
    if (keyword.isEmpty) return items;

    return items.where((item) {
      return item.name.toLowerCase().contains(keyword) ||
          item.status.toLowerCase().contains(keyword);
    }).toList();
  }

  bool get hasData => filteredItems.isNotEmpty;

  int get totalPages {
    final total = filteredItems.length;
    if (total == 0) return 1;
    return (total / pageSize).ceil();
  }

  List<SymptomItem> get paginatedItems {
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
    symptomC.clear();
    selectedStatus.value = 'Aktif';
  }

  String? validateSymptom(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama gejala wajib diisi';
    }
    if (value.trim().length < 2) {
      return 'Nama gejala minimal 2 karakter';
    }
    return null;
  }

  Widget _buildFormBody() {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFieldCustom(
            hintText: 'Masukkan nama gejala',
            lebel: 'Nama Gejala',
            controller: symptomC,
            validator: validateSymptom,
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
          title: 'Tambah Gejala',
          subtitle: 'Lengkapi data gejala yang akan digunakan sistem.',
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

  void openEditDialog(SymptomItem item) {
    symptomC.text = item.name;
    selectedStatus.value = item.status;

    Get.dialog(
      Obx(
        () => FormDialog(
          title: 'Edit Gejala',
          subtitle: 'Perbarui data gejala yang dipilih.',
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
      await _symptomService.createSymptom(
        name: symptomC.text.trim(),
        status: selectedStatus.value,
        createdBy: currentUser.uid,
      );

      await loadInitialData();
      clearForm();
      Get.back();

      Get.snackbar(
        'Berhasil',
        'Gejala berhasil ditambahkan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      debugPrint('[SYMPTOMS][ADD ERROR] $e');
      debugPrint('[SYMPTOMS][STACKTRACE] $stackTrace');

      Get.snackbar(
        'Gagal',
        'Gejala gagal ditambahkan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> updateItem(SymptomItem item) async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    isSubmitting.value = true;

    try {
      await _symptomService.updateSymptom(
        docId: item.docId,
        name: symptomC.text.trim(),
        status: selectedStatus.value,
      );

      await loadInitialData();
      Get.back();

      Get.snackbar(
        'Berhasil',
        'Gejala berhasil diperbarui.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      debugPrint('[SYMPTOMS][UPDATE ERROR] $e');
      debugPrint('[SYMPTOMS][STACKTRACE] $stackTrace');

      Get.snackbar(
        'Gagal',
        'Gejala gagal diperbarui.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void deleteItem(SymptomItem item) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Gejala'),
        content: Text('Yakin ingin menghapus gejala "${item.name}"?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _symptomService.deleteSymptom(item.docId);
                await loadInitialData();

                if (currentPage.value > totalPages) {
                  currentPage.value = totalPages;
                }

                Get.back();
                Get.snackbar(
                  'Berhasil',
                  'Gejala ${item.name} dihapus.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              } catch (e, stackTrace) {
                debugPrint('[SYMPTOMS][DELETE ERROR] $e');
                debugPrint('[SYMPTOMS][STACKTRACE] $stackTrace');

                Get.back();
                Get.snackbar(
                  'Gagal',
                  'Gejala gagal dihapus.',
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
    symptomC.dispose();
    super.onClose();
  }
}
