part of '../../pages.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late final ReportsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<ReportsController>()
        ? Get.find<ReportsController>()
        : Get.put(ReportsController());
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
                title: 'Laporan Konsultasi',
                subtitle: 'Pantau rekap hasil konsultasi berdasarkan kategori.',
              ),
              const SizedBox(height: 20),
              TextFieldCustom(
                hintText: 'Cari tanggal, kategori, total, tren...',
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
                onChanged: (_) {
                  controller.resetPage();
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              if (controller.isLoading.value)
                const CircularIndicator()
              else if (controller.filteredReports.isEmpty)
                const EmptyState(
                  icon: Icons.insert_chart_outlined_rounded,
                  title: 'Laporan tidak ditemukan',
                  subtitle:
                      'Belum ada data yang sesuai dengan filter pencarian.',
                )
              else ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 240,
                    columns: const [
                      DataColumn(label: Text('Tanggal')),
                      DataColumn(label: Text('Kategori')),
                      DataColumn(label: Text('Total')),
                      DataColumn(label: Text('Tren')),
                    ],
                    rows: controller.paginatedReports.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item.date)),
                          DataCell(Text(item.category)),
                          DataCell(Text(item.total)),
                          DataCell(Text(item.trend)),
                        ],
                      );
                    }).toList(),
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
      );
    });
  }
}
