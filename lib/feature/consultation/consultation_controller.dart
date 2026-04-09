part of '../../pages.dart';

class ConsultationController extends GetxController {
  final searchC = TextEditingController();

  final isLoading = false.obs;
  final isSubmitting = false.obs;

  final selectedSymptoms = <String>[].obs;
  final result = Rxn<ConsultationResult>();

  final symptoms = <String>[].obs;

  final ConsultationService _service = ConsultationService.instance;
  final AuthService _authService = AuthService.instance;

  List<Map<String, dynamic>> rules = [];

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;

      symptoms.value = await _service.getSymptoms();
      rules = await _service.getRules();
    } catch (e) {
      Get.snackbar('Error', 'Gagal load data');
    } finally {
      isLoading.value = false;
    }
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
      Get.snackbar('Validasi', 'Pilih minimal satu gejala.');
      return;
    }

    isSubmitting.value = true;
    debugPrint('========== SUBMIT CONSULTATION START ==========');

    try {
      final res = _generateResultFromRules(selectedSymptoms);
      result.value = res;

      final user = _authService.currentUser;
      debugPrint('[CONSULTATION] currentUser = ${user?.uid}');
      debugPrint('[CONSULTATION] result = ${res.category}');
      debugPrint('[CONSULTATION] recommendation = ${res.recommendation}');
      debugPrint('[CONSULTATION] selectedSymptoms = $selectedSymptoms');

      if (user != null) {
        await _service.saveConsultation(
          userId: user.uid,
          symptoms: selectedSymptoms,
          result: res.category,
          recommendation: res.recommendation,
        );

        debugPrint('[CONSULTATION] consultation saved to firestore');

        if (Get.isRegistered<DashboardController>()) {
          debugPrint('[CONSULTATION] refreshing DashboardController...');
          await Get.find<DashboardController>().loadUserDashboard();
        }
      }

      Get.snackbar('Berhasil', 'Hasil konsultasi disimpan');
      debugPrint('========== SUBMIT CONSULTATION SUCCESS ==========');
    } catch (e, stackTrace) {
      debugPrint('[CONSULTATION][ERROR] $e');
      debugPrint('[CONSULTATION][STACKTRACE] $stackTrace');
      Get.snackbar('Error', 'Gagal proses konsultasi');
    } finally {
      isSubmitting.value = false;
      debugPrint('========== SUBMIT CONSULTATION END ==========');
    }
  }

  ConsultationResult _generateResultFromRules(List<String> selected) {
    for (final rule in rules) {
      final condition = (rule['condition'] ?? '').toString().toLowerCase();
      final result = (rule['result'] ?? '').toString();

      final matched = selected.every(
        (symptom) => condition.contains(symptom.toLowerCase()),
      );

      if (matched) {
        return ConsultationResult(
          title: 'Hasil Konsultasi',
          category: result,
          recommendation: 'Rekomendasi berdasarkan rule pakar',
          selectedSymptoms: selected,
        );
      }
    }

    return ConsultationResult(
      title: 'Hasil Konsultasi',
      category: 'Tidak ditemukan',
      recommendation: 'Tidak ada rule yang cocok',
      selectedSymptoms: selected,
    );
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
