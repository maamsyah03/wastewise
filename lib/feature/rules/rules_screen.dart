part of '../../pages.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  late final RulesController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<RulesController>()
        ? Get.find<RulesController>()
        : Get.put(RulesController());
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
                title: 'Kelola Rule',
                subtitle:
                    'Tambah, edit, hapus, dan cari rule forward chaining.',
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
                            label: 'Tambah Rule',
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
                          label: 'Tambah Rule',
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
                  icon: Icons.rule_folder_outlined,
                  title: 'Data rule kosong',
                  subtitle: 'Belum ada rule yang sesuai dengan pencarian.',
                  buttonLabel: 'Tambah Rule',
                  onPressed: controller.openAddDialog,
                )
              else ...[
                TableData<RuleItemModel>(
                  items: controller.paginatedItems,
                  columns: [
                    AppTableColumn<RuleItemModel>(
                      title: 'ID',
                      width: 60,
                      cellBuilder: (item) => Text(item.id.toString()),
                    ),
                    AppTableColumn<RuleItemModel>(
                      title: 'Kondisi',
                      width: 260,
                      cellBuilder: (item) => Text(
                        item.condition,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppTableColumn<RuleItemModel>(
                      title: 'Hasil',
                      width: 180,
                      cellBuilder: (item) => Text(
                        item.result,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppTableColumn<RuleItemModel>(
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
      hintText: 'Cari kondisi, hasil, atau status...',
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
