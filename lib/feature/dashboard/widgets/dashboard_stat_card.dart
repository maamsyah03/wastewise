part of '../../../pages.dart';

class DashboardStatCard extends StatelessWidget {
  final DashboardStatItem item;

  const DashboardStatCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: const Color(0xFF155EEF)),
          ),
          const SizedBox(height: 16),
          Text(
            item.title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF101828),
            ),
          ),
          if (item.footer != null) ...[
            const SizedBox(height: 10),
            Text(
              item.footer!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}