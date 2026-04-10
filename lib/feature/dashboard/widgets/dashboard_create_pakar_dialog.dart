part of '../../../pages.dart';

class DashboardCreatePakarDialog extends StatelessWidget {
  final DashboardController controller;

  const DashboardCreatePakarDialog({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          width: 460,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Form(
            key: controller.pakarFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Buat Akun Pakar',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF101828),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Admin dapat membuat akun baru khusus untuk role pakar.',
                    style: TextStyle(
                      color: Color(0xFF667085),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextFieldCustom(
                    hintText: 'Masukkan username',
                    lebel: 'Username',
                    controller: controller.pakarUsernameC,
                    validator: controller.validatePakarUsername,
                    cursorHeight: 20,
                    cursorColor: Colors.black87,
                    fillColor: const Color(0xFFF8FAFC),
                    hintColor: Colors.grey,
                    borderRadius: 16,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
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
                  const SizedBox(height: 14),

                  TextFieldCustom(
                    hintText: 'Masukkan email',
                    lebel: 'Email',
                    controller: controller.pakarEmailC,
                    validator: controller.validatePakarEmail,
                    cursorHeight: 20,
                    cursorColor: Colors.black87,
                    fillColor: const Color(0xFFF8FAFC),
                    hintColor: Colors.grey,
                    borderRadius: 16,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
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
                  const SizedBox(height: 14),

                  TextFieldCustom(
                    hintText: 'Masukkan password',
                    lebel: 'Password',
                    controller: controller.pakarPasswordC,
                    validator: controller.validatePakarPassword,
                    obscureText: controller.isPakarPasswordHidden.value,
                    cursorHeight: 20,
                    cursorColor: Colors.black87,
                    fillColor: const Color(0xFFF8FAFC),
                    hintColor: Colors.grey,
                    borderRadius: 16,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    onChanged: (_) {
                      controller.pakarFormKey.currentState?.validate();
                    },
                    enabledBorderSide: const BorderSide(
                      color: Color(0xFFD0D5DD),
                    ),
                    focusedBorderSide: const BorderSide(
                      color: Color(0xFF0F5EF7),
                      width: 1.4,
                    ),
                    errorBorderSide: const BorderSide(color: Colors.red),
                    suffixIcon: IconButton(
                      onPressed: controller.togglePakarPasswordVisibility,
                      icon: Icon(
                        controller.isPakarPasswordHidden.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  TextFieldCustom(
                    hintText: 'Ulangi password',
                    lebel: 'Konfirmasi Password',
                    controller: controller.pakarConfirmPasswordC,
                    validator: controller.validatePakarConfirmPassword,
                    obscureText: controller.isPakarConfirmPasswordHidden.value,
                    cursorHeight: 20,
                    cursorColor: Colors.black87,
                    fillColor: const Color(0xFFF8FAFC),
                    hintColor: Colors.grey,
                    borderRadius: 16,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    onChanged: (_) {
                      controller.pakarFormKey.currentState?.validate();
                    },
                    enabledBorderSide: const BorderSide(
                      color: Color(0xFFD0D5DD),
                    ),
                    focusedBorderSide: const BorderSide(
                      color: Color(0xFF0F5EF7),
                      width: 1.4,
                    ),
                    errorBorderSide: const BorderSide(color: Colors.red),
                    suffixIcon: IconButton(
                      onPressed: controller.togglePakarConfirmPasswordVisibility,
                      icon: Icon(
                        controller.isPakarConfirmPasswordHidden.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: controller.isCreatingPakar.value
                            ? null
                            : Get.back,
                        child: const Text('Batal'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: controller.isCreatingPakar.value
                            ? null
                            : controller.createPakarAccount,
                        child: controller.isCreatingPakar.value
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                            : const Text('Simpan'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}