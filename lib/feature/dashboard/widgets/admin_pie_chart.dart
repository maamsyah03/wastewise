part of '../../../pages.dart';

class AdminPieChart extends StatelessWidget {
  final List<DashboardPieItem> items;

  const AdminPieChart({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('Belum ada data distribusi.'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 520;

        if (isCompact) {
          return Column(
            children: [
              SizedBox(
                height: 220,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 44,
                    sections: _buildSections(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLegend(),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              flex: 3,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 50,
                  sections: _buildSections(),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(flex: 2, child: _buildLegend()),
          ],
        );
      },
    );
  }

  List<PieChartSectionData> _buildSections() {
    return items.map((item) {
      return PieChartSectionData(
        value: item.value,
        color: item.color,
        radius: 58,
        title: '${item.value.toInt()}%',
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF344054),
                  ),
                ),
              ),
              Text(
                '${item.value.toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF101828),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
