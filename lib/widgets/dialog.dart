part of '../pages.dart';

class FormDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String submitLabel;
  final GlobalKey<FormState>? formKey;
  final Widget child;
  final VoidCallback onSubmit;
  final VoidCallback? onCancel;
  final bool isSubmitting;
  final double width;

  const FormDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.submitLabel,
    required this.child,
    required this.onSubmit,
    this.formKey,
    this.onCancel,
    this.isSubmitting = false,
    this.width = 460,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF101828),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF667085),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              child,
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isSubmitting
                        ? null
                        : (onCancel ?? () => Get.back()),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: isSubmitting ? null : onSubmit,
                    child: isSubmitting
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : Text(submitLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}