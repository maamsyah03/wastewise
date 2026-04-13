part of '../../pages.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  late final ConsultationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<ConsultationController>()
        ? Get.find<ConsultationController>()
        : Get.put(ConsultationController());

    controller.refreshData();
    controller.searchC.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.searchC.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filteredSymptoms = controller.filteredSymptoms;
      final consultationResult = controller.result.value;

      return SingleChildScrollView(
        child: Column(
          children: [
            DashboardCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardSectionTitle(
                    title: 'Konsultasi Identifikasi Sampah',
                    subtitle:
                    'Pilih gejala yang paling sesuai untuk mendapatkan hasil identifikasi.',
                  ),
                  const SizedBox(height: 20),
                  TextFieldCustom(
                    hintText: 'Cari gejala...',
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
                    errorBorderSide: const BorderSide(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  if (controller.isLoading.value)
                    const CircularIndicator()
                  else if (filteredSymptoms.isEmpty)
                    EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'Gejala tidak ditemukan',
                      subtitle: 'Coba gunakan kata kunci lain.',
                      buttonLabel: 'Reset Pencarian',
                      onPressed: () => controller.searchC.clear(),
                    )
                  else
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: filteredSymptoms.map((symptom) {
                        final selected = controller.selectedSymptoms.contains(
                          symptom,
                        );

                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => controller.toggleSymptom(symptom),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFFEFF4FF)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF155EEF)
                                    : const Color(0xFFD0D5DD),
                              ),
                            ),
                            child: Text(capitalize(symptom),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? const Color(0xFF155EEF)
                                    : const Color(0xFF344054),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ActionButton(
                          label: controller.isSubmitting.value
                              ? 'Memproses...'
                              : 'Proses Konsultasi',
                          icon: Icons.play_circle_outline_rounded,
                          onTap: controller.isSubmitting.value
                              ? null
                              : controller.submitConsultation,
                          isExpanded: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: controller.clearAll,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (consultationResult != null) ...[
              const SizedBox(height: 20),
              DashboardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DashboardSectionTitle(
                      title: 'Hasil Konsultasi',
                      subtitle:
                      'Berikut hasil identifikasi berdasarkan gejala yang dipilih.',
                    ),
                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE4E7EC)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kategori Sampah',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF667085),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            consultationResult.category,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF101828),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Gejala Dipilih',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF344054),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: consultationResult.selectedSymptoms.map((item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF4FF),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: const Color(0xFFB2CCFF),
                            ),
                          ),
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF155EEF),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE4E7EC)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rekomendasi Pengelolaan',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF344054),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            consultationResult.recommendation,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: ActionButton(
                            label: 'Konsultasi Lagi',
                            icon: Icons.refresh_rounded,
                            onTap: controller.resetAfterResult,
                            isExpanded: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}