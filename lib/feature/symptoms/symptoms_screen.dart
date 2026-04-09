part of '../../pages.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  late final SymptomsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<SymptomsController>()
        ? Get.find<SymptomsController>()
        : Get.put(SymptomsController());
  }

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 760;

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    return Obx(
          () => SingleChildScrollView(
        child: DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardSectionTitle(
                title: 'Kelola Gejala',
                subtitle: 'Tambah, edit, hapus, dan cari data gejala.',
              ),
              const SizedBox(height: 20),
              isMobile
                  ? Column(
                children: [
                  _buildSearchField(),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ActionButton(
                      label: 'Tambah Gejala',
                      icon: Icons.add,
                      onTap: controller.openAddDialog,
                    ),
                  ),
                ],
              )
                  : Row(
                children: [
                  Expanded(child: _buildSearchField()),
                  const SizedBox(width: 12),
                  ActionButton(
                    label: 'Tambah Gejala',
                    icon: Icons.add,
                    onTap: controller.openAddDialog,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (controller.isLoading.value)
                const CircularIndicator()
              else if (!controller.hasData)
                EmptyState(
                  icon: Icons.list_alt_outlined,
                  title: 'Data gejala kosong',
                  subtitle: 'Belum ada gejala yang cocok dengan pencarian.',
                  buttonLabel: 'Tambah Gejala',
                  onPressed: controller.openAddDialog,
                )
              else ...[
                  TableData<SymptomItem>(
                    columnSpacing: 150,
                    items: controller.paginatedItems,
                    columns: [
                      AppTableColumn<SymptomItem>(
                        title: 'ID',
                        width: 60,
                        cellBuilder: (item) => Text(item.id.toString()),
                      ),
                      AppTableColumn<SymptomItem>(
                        title: 'Nama Gejala',
                        width: 260,
                        cellBuilder: (item) => Text(capitalize(item.name),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AppTableColumn<SymptomItem>(
                        title: 'Status',
                        width: 120,
                        cellBuilder: (item) => Text(item.status),
                      ),
                    ],
                    actionBuilder: (item) => Row(
                      children: [
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () => controller.openEditDialog(item),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () => controller.deleteItem(item),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
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
      ),
    );
  }

  Widget _buildSearchField() {
    return TextFieldCustom(
      hintText: 'Cari nama gejala atau status...',
      lebel: '',
      controller: controller.searchC,
      cursorHeight: 20,
      cursorColor: Colors.black87,
      fillColor: const Color(0xFFF8FAFC),
      hintColor: Colors.grey,
      borderRadius: 16,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      prefixIcon: const Icon(
        Icons.search,
        color: Color(0xFF667085),
        size: 20,
      ),
      enabledBorderSide: const BorderSide(
        color: Color(0xFFD0D5DD),
      ),
      focusedBorderSide: const BorderSide(
        color: Color(0xFF0F5EF7),
        width: 1.4,
      ),
      errorBorderSide: const BorderSide(
        color: Colors.red,
      ),
    );
  }
}