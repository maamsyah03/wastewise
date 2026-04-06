part of '../pages.dart';

class Pagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const Pagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onPrev,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: currentPage > 1 ? onPrev : null,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Prev'),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE4E7EC)),
          ),
          child: Text(
            '$currentPage / $totalPages',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF344054),
            ),
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: currentPage < totalPages ? onNext : null,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Next'),
        ),
      ],
    );
  }
}
