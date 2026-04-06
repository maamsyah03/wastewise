part of '../../../pages.dart';

class ExpertBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const ExpertBarChart({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('Belum ada data rule.'));
    }

    final maxValue = items
        .map((e) => (e['value'] as num).toDouble())
        .fold<double>(0, (prev, value) => value > prev ? value : prev);

    final double chartMaxY = maxValue <= 5
        ? 5.0
        : ((maxValue / 5).ceil() * 5).toDouble();

    return BarChart(
      BarChartData(
        maxY: chartMaxY,
        minY: 0,
        alignment: BarChartAlignment.spaceAround,
        gridData: FlGridData(
          show: true,
          horizontalInterval: chartMaxY / 4,
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xFFE4E7EC)),
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 34,
              interval: chartMaxY / 4,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 11),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 34,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= items.length) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    items[index]['label'] as String,
                    style: const TextStyle(fontSize: 11),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: List.generate(items.length, (index) {
          final item = items[index];
          final double toY = (item['value'] as num).toDouble();

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: toY,
                width: 22,
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF155EEF),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: chartMaxY,
                  color: const Color(0xFFF2F4F7),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}