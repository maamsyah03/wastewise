part of '../../pages.dart';

class UsersController extends GetxController {
  final searchC = TextEditingController();
  final nameC = TextEditingController();
  final usernameC = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final currentPage = 1.obs;

  final selectedRole = 'User'.obs;
  final selectedStatus = 'Aktif'.obs;

  final users = <UserManagementItem>[].obs;

  final int pageSize = 5;

  final List<String> roleOptions = const ['User', 'Pakar', 'Admin'];
  final List<String> statusOptions = const ['Aktif', 'Nonaktif'];

  final AdminService _adminService = AdminService.instance;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
    searchC.addListener(_handleSearchChanged);
  }

  Future<void> loadInitialData() async {
    debugPrint('========== LOAD USERS START ==========');
    try {
      isLoading.value = true;

      final results = await _adminService.getUsers();

      users.assignAll(
        results.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final docId = (data['docId'] ?? '').toString();

          return UserManagementItem.fromFirestore(
            docId: docId,
            index: index,
            data: data,
          );
        }).toList(),
      );

      debugPrint('[USERS] total loaded = ${users.length}');
    } catch (e, stackTrace) {
      debugPrint('[USERS][ERROR] $e');
      debugPrint('[USERS][STACKTRACE] $stackTrace');

      Get.snackbar(
        'Gagal',
        'Data pengguna gagal dimuat.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      debugPrint('========== LOAD USERS END ==========');
    }
  }

  void _handleSearchChanged() {
    currentPage.value = 1;
  }

  String get keyword => searchC.text.trim().toLowerCase();

  List<UserManagementItem> get filteredUsers {
    if (keyword.isEmpty) return users;

    return users.where((item) {
      return item.name.toLowerCase().contains(keyword) ||
          item.email.toLowerCase().contains(keyword) ||
          item.role.toLowerCase().contains(keyword) ||
          item.status.toLowerCase().contains(keyword);
    }).toList();
  }

  int get totalPages {
    final total = filteredUsers.length;
    if (total == 0) return 1;
    return (total / pageSize).ceil();
  }

  List<UserManagementItem> get paginatedUsers {
    final data = filteredUsers;
    final start = (currentPage.value - 1) * pageSize;

    if (start >= data.length) return [];

    final end = (start + pageSize > data.length)
        ? data.length
        : start + pageSize;
    return data.sublist(start, end);
  }

  bool get hasData => filteredUsers.isNotEmpty;

  void nextPage() {
    if (currentPage.value < totalPages) currentPage.value++;
  }

  void prevPage() {
    if (currentPage.value > 1) currentPage.value--;
  }

  void resetPage() {
    currentPage.value = 1;
  }

  void clearForm() {
    formKey.currentState?.reset();
    nameC.clear();
    usernameC.clear();
    selectedRole.value = 'User';
    selectedStatus.value = 'Aktif';
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama wajib diisi';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  void setRole(String? value) {
    if (value != null) selectedRole.value = value;
  }

  void setStatus(String? value) {
    if (value != null) selectedStatus.value = value;
  }

  Widget _buildFormBody() {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFieldCustom(
            hintText: 'Masukkan nama lengkap',
            lebel: 'Nama',
            controller: nameC,
            validator: validateName,
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
            hintText: 'Email pengguna',
            readOnly: true,
            lebel: 'Email',
            controller: usernameC,
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
            value: selectedRole.value,
            items: roleOptions
                .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                .toList(),
            onChanged: setRole,
            decoration: InputDecoration(
              labelText: 'Role',
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF0F5EF7),
                  width: 1.4,
                ),
              ),
            ),
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
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF0F5EF7),
                  width: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openAddDialog() {
    Get.snackbar(
      'Info',
      'Penambahan user baru sebaiknya lewat signup / create account admin.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openEditDialog(UserManagementItem item) {
    nameC.text = item.name;
    usernameC.text = item.email;
    selectedRole.value = item.role;
    selectedStatus.value = item.status;

    Get.dialog(
      Obx(
        () => FormDialog(
          title: 'Edit Pengguna',
          subtitle: 'Perbarui informasi pengguna yang dipilih.',
          submitLabel: 'Update',
          formKey: formKey,
          isSubmitting: isSubmitting.value,
          onSubmit: () => updateUser(item),
          child: _buildFormBody(),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> updateUser(UserManagementItem item) async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    isSubmitting.value = true;

    try {
      await _adminService.updateUser(
        docId: item.docId,
        name: nameC.text.trim(),
        role: selectedRole.value,
        status: selectedStatus.value,
      );

      await loadInitialData();
      Get.back();

      Get.snackbar(
        'Berhasil',
        'Pengguna berhasil diperbarui.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      debugPrint('[USERS][UPDATE ERROR] $e');
      debugPrint('[USERS][STACKTRACE] $stackTrace');

      Get.snackbar(
        'Gagal',
        'Pengguna gagal diperbarui.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void deleteUser(UserManagementItem item) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Pengguna'),
        content: Text('Yakin ingin menghapus ${item.name}?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _adminService.deleteUser(item.docId);
                await loadInitialData();

                if (currentPage.value > totalPages) {
                  currentPage.value = totalPages;
                }

                Get.back();
                Get.snackbar(
                  'Berhasil',
                  'Pengguna ${item.name} dihapus.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              } catch (e, stackTrace) {
                debugPrint('[USERS][DELETE ERROR] $e');
                debugPrint('[USERS][STACKTRACE] $stackTrace');

                Get.back();
                Get.snackbar(
                  'Gagal',
                  'Pengguna gagal dihapus.',
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
    searchC.removeListener(_handleSearchChanged);
    searchC.dispose();
    nameC.dispose();
    usernameC.dispose();
    super.onClose();
  }
}
