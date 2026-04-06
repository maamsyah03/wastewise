part of '../../../pages.dart';

class DashboardHeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const DashboardHeaderButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE4E7EC)),
          ),
          child: Icon(icon, color: const Color(0xFF344054)),
        ),
      ),
    );
  }
}