part of '../../pages.dart';

class ConsultationController extends GetxController {
  final searchC = TextEditingController();

  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final selectedSymptoms = <String>[].obs;
  final result = Rxn<ConsultationResult>();

  final symptoms = <String>[
    'Basah',
    'Berbau',
    'Mudah membusuk',
    'Kering',
    'Keras',
    'Plastik',
    'Kaca',
    'Kertas',
    'Beracun',
    'Logam',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 700));
    isLoading.value = false;
  }

  List<String> get filteredSymptoms {
    final keyword = searchC.text.trim().toLowerCase();
    if (keyword.isEmpty) return symptoms;

    return symptoms.where((e) => e.toLowerCase().contains(keyword)).toList();
  }

  void toggleSymptom(String symptom) {
    if (selectedSymptoms.contains(symptom)) {
      selectedSymptoms.remove(symptom);
    } else {
      selectedSymptoms.add(symptom);
    }
  }

  Future<void> submitConsultation() async {
    if (selectedSymptoms.isEmpty) {
      Get.snackbar(
        'Validasi',
        'Pilih minimal satu gejala.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSubmitting.value = true;

    try {
      await Future.delayed(const Duration(seconds: 1));

      result.value = _generateResult(selectedSymptoms);

      Get.snackbar(
        'Berhasil',
        'Hasil konsultasi berhasil ditampilkan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  ConsultationResult _generateResult(List<String> selected) {
    final lower = selected.map((e) => e.toLowerCase()).toList();

    final isOrganic =
        lower.contains('basah') ||
            lower.contains('berbau') ||
            lower.contains('mudah membusuk');

    final isB3 = lower.contains('beracun');

    final isAnorganic =
        lower.contains('plastik') ||
            lower.contains('kaca') ||
            lower.contains('logam') ||
            lower.contains('keras') ||
            lower.contains('kering') ||
            lower.contains('kertas');

    if (isB3) {
      return ConsultationResult(
        title: 'Hasil Konsultasi',
        category: 'Sampah B3',
        recommendation:
        'Pisahkan dari sampah rumah tangga biasa dan serahkan ke pengelola limbah khusus agar aman.',
        selectedSymptoms: List<String>.from(selected),
      );
    }

    if (isOrganic && !isAnorganic) {
      return ConsultationResult(
        title: 'Hasil Konsultasi',
        category: 'Sampah Organik',
        recommendation:
        'Disarankan dikelola melalui kompos, biokonversi, atau pemisahan sampah organik rumah tangga.',
        selectedSymptoms: List<String>.from(selected),
      );
    }

    if (isAnorganic && !isOrganic) {
      return ConsultationResult(
        title: 'Hasil Konsultasi',
        category: 'Sampah Anorganik',
        recommendation:
        'Pisahkan untuk didaur ulang atau dikumpulkan ke bank sampah sesuai jenis materialnya.',
        selectedSymptoms: List<String>.from(selected),
      );
    }

    return ConsultationResult(
      title: 'Hasil Konsultasi',
      category: 'Perlu Identifikasi Lanjutan',
      recommendation:
      'Gejala yang dipilih menunjukkan campuran kategori. Disarankan pemilahan lebih detail sebelum pengelolaan.',
      selectedSymptoms: List<String>.from(selected),
    );
  }

  void clearSelection() {
    selectedSymptoms.clear();
  }

  void clearAll() {
    searchC.clear();
    selectedSymptoms.clear();
    result.value = null;
  }

  void resetAfterResult() {
    clearAll();
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}