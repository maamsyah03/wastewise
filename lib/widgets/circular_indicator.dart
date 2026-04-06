part of '../pages.dart';

class CircularIndicator extends StatelessWidget {
  final String label;

  const CircularIndicator({
    super.key,
    this.label = 'Memuat data...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 34,
              height: 34,
              child: CircularProgressIndicator(strokeWidth: 2.6),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF667085),
              ),
            ),
          ],
        ),
      ),
    );
  }
}