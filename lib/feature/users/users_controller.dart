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

  @override
  void onInit() {
    super.onInit();
    _seedData();
    loadInitialData();
    searchC.addListener(_handleSearchChanged);
  }

  void _seedData() {
    users.assignAll(const [
      UserManagementItem(
        id: 1,
        name: 'Raya',
        username: 'raya01',
        role: 'User',
        status: 'Aktif',
      ),
      UserManagementItem(
        id: 2,
        name: 'Novi',
        username: 'novi02',
        role: 'Pakar',
        status: 'Aktif',
      ),
      UserManagementItem(
        id: 3,
        name: 'Andre',
        username: 'andre03',
        role: 'Admin',
        status: 'Aktif',
      ),
      UserManagementItem(
        id: 4,
        name: 'Dina',
        username: 'dina04',
        role: 'User',
        status: 'Nonaktif',
      ),
      UserManagementItem(
        id: 5,
        name: 'Bimo',
        username: 'bimo05',
        role: 'User',
        status: 'Aktif',
      ),
      UserManagementItem(
        id: 6,
        name: 'Raka',
        username: 'raka06',
        role: 'Pakar',
        status: 'Aktif',
      ),
    ]);
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 700));
    isLoading.value = false;
  }

  void _handleSearchChanged() {
    currentPage.value = 1;
  }

  String get keyword => searchC.text.trim().toLowerCase();

  List<UserManagementItem> get filteredUsers {
    if (keyword.isEmpty) return users;

    return users.where((item) {
      return item.name.toLowerCase().contains(keyword) ||
          item.username.toLowerCase().contains(keyword) ||
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

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username wajib diisi';
    }
    if (value.trim().length < 3) {
      return 'Username minimal 3 karakter';
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
            hintText: 'Masukkan username',
            lebel: 'Username',
            controller: usernameC,
            validator: validateUsername,
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
    clearForm();

    Get.dialog(
      Obx(
        () => FormDialog(
          title: 'Tambah Pengguna',
          subtitle: 'Lengkapi informasi pengguna di bawah ini.',
          submitLabel: 'Simpan',
          formKey: formKey,
          isSubmitting: isSubmitting.value,
          onSubmit: addUser,
          child: _buildFormBody(),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void openEditDialog(UserManagementItem item) {
    nameC.text = item.name;
    usernameC.text = item.username;
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

  Future<void> addUser() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    isSubmitting.value = true;

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      final nextId = users.isEmpty
          ? 1
          : users.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

      users.add(
        UserManagementItem(
          id: nextId,
          name: nameC.text.trim(),
          username: usernameC.text.trim(),
          role: selectedRole.value,
          status: selectedStatus.value,
        ),
      );

      Get.back();
      Get.snackbar(
        'Berhasil',
        'Pengguna berhasil ditambahkan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> updateUser(UserManagementItem item) async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    isSubmitting.value = true;

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      final index = users.indexWhere((e) => e.id == item.id);
      if (index == -1) return;

      users[index] = item.copyWith(
        name: nameC.text.trim(),
        username: usernameC.text.trim(),
        role: selectedRole.value,
        status: selectedStatus.value,
      );
      users.refresh();

      Get.back();
      Get.snackbar(
        'Berhasil',
        'Pengguna berhasil diperbarui.',
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
            onPressed: () {
              users.removeWhere((e) => e.id == item.id);

              if (currentPage.value > totalPages) {
                currentPage.value = totalPages;
              }

              Get.back();
              Get.snackbar(
                'Berhasil',
                'Pengguna ${item.name} dihapus.',
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
    searchC.removeListener(_handleSearchChanged);
    searchC.dispose();
    nameC.dispose();
    usernameC.dispose();
    super.onClose();
  }
}
