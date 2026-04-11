part of '../../pages.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late final UsersController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<UsersController>()
        ? Get.find<UsersController>()
        : Get.put(UsersController());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        child: DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardSectionTitle(
                title: 'Kelola Pengguna',
                subtitle: 'Tambah, edit, hapus, dan cari akun pengguna.',
              ),
              const SizedBox(height: 20),
              _buildSearchField(),
              const SizedBox(height: 20),
              if (controller.isLoading.value)
                const CircularIndicator()
              else if (!controller.hasData)
                EmptyState(
                  icon: Icons.group_off_outlined,
                  title: 'Data pengguna kosong',
                  subtitle: 'Belum ada data yang sesuai dengan pencarian.',
                  buttonLabel: 'Tambah Pengguna',
                  onPressed: controller.openAddDialog,
                )
              else ...[
                TableData<UserManagementItem>(
                  columnSpacing: 15,
                  items: controller.paginatedUsers,
                  columns: [
                    AppTableColumn<UserManagementItem>(
                      title: 'ID',
                      width: 60,
                      cellBuilder: (item) => Text(item.id.toString()),
                    ),
                    AppTableColumn<UserManagementItem>(
                      title: 'Nama',
                      width: 220,
                      cellBuilder: (item) => Text(
                        capitalize(item.name),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppTableColumn<UserManagementItem>(
                      title: 'Email',
                      width: 300,
                      cellBuilder: (item) => Text(
                        item.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppTableColumn<UserManagementItem>(
                      title: 'Role',
                      width: 120,
                      cellBuilder: (item) => Text(item.role),
                    ),
                    AppTableColumn<UserManagementItem>(
                      title: 'Status',
                      width: 120,
                      cellBuilder: (item) => Text(item.status),
                    ),
                  ],
                  actionBuilder: (item) {
                    final isSelf = controller.isCurrentLoggedInUser(item);

                    return isSelf
                        ? SizedBox.shrink()
                        : Row(
                            children: [
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                onPressed: () =>
                                    controller.openEditDialog(item),
                                icon: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                onPressed: () => controller.deleteUser(item),
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 16),
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
      hintText: 'Cari nama, email, role, status...',
      lebel: '',
      controller: controller.searchC,
      cursorHeight: 20,
      cursorColor: Colors.black87,
      fillColor: const Color(0xFFF8FAFC),
      hintColor: Colors.grey,
      borderRadius: 16,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      prefixIcon: const Icon(Icons.search, color: Color(0xFF667085), size: 20),
      enabledBorderSide: const BorderSide(color: Color(0xFFD0D5DD)),
      focusedBorderSide: const BorderSide(color: Color(0xFF0F5EF7), width: 1.4),
      errorBorderSide: const BorderSide(color: Colors.red),
    );
  }
}
