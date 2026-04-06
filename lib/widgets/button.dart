part of '../pages.dart';

Widget ReusableButton({
  required String label,
  required VoidCallback onTap,
  Color? backgroundColor,
  Color? borderColor,
  Color? textColor,
  FontWeight fontWeight = FontWeight.normal,
  double borderRadius = 10,
  EdgeInsets padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
  EdgeInsets margin = const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
  double? height,
  Widget? icon,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: padding,
      margin: margin,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(width: 1, color: borderColor ?? Colors.transparent),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon,
            SizedBox(width: 10),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor ?? Colors.transparent,
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    ),
  );
}

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isExpanded;
  final bool isLoading;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.isExpanded = false,
    this.isLoading = false,
    this.backgroundColor = const Color(0xFFEFF4FF),
    this.borderColor = const Color(0xFFB2CCFF),
    this.textColor = const Color(0xFF155EEF),
    this.iconColor = const Color(0xFF155EEF),
  });

  @override
  Widget build(BuildContext context) {
    final child = Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: isLoading ? null : onTap,
        child: Container(
          width: isExpanded ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: textColor,
                  ),
                ),
              ] else ...[
                Icon(icon, color: iconColor, size: 20),
              ],
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: child);
    }

    return child;
  }
}