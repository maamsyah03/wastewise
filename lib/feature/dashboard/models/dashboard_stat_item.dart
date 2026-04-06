part of '../../../pages.dart';

class DashboardStatItem {
  final String title;
  final String value;
  final String? footer;
  final IconData icon;

  const DashboardStatItem({
    required this.title,
    required this.value,
    required this.icon,
    this.footer,
  });
}