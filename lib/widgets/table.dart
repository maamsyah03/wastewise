part of '../pages.dart';

class AppTableColumn<T> {
  final String title;
  final double width;
  final Widget Function(T item) cellBuilder;

  const AppTableColumn({
    required this.title,
    required this.width,
    required this.cellBuilder,
  });
}

class TableData<T> extends StatelessWidget {
  final List<T> items;
  final List<AppTableColumn<T>> columns;
  final Widget Function(T item)? actionBuilder;
  final String actionTitle;
  final double actionWidth;
  final double columnSpacing;
  final double horizontalMargin;
  final double headingRowHeight;
  final double dataRowMinHeight;
  final double dataRowMaxHeight;

  const TableData({
    super.key,
    required this.items,
    required this.columns,
    this.actionBuilder,
    this.actionTitle = 'Aksi',
    this.actionWidth = 120,
    this.columnSpacing = 24,
    this.horizontalMargin = 16,
    this.headingRowHeight = 52,
    this.dataRowMinHeight = 56,
    this.dataRowMaxHeight = 64,
  });

  @override
  Widget build(BuildContext context) {
    final allColumns = <DataColumn>[
      ...columns.map(
        (column) => DataColumn(
          label: SizedBox(width: column.width, child: Text(column.title)),
        ),
      ),
      if (actionBuilder != null)
        DataColumn(
          label: SizedBox(width: actionWidth, child: Text(actionTitle)),
        ),
    ];

    final allRows = items.map((item) {
      return DataRow(
        cells: [
          ...columns.map(
            (column) => DataCell(
              SizedBox(width: column.width, child: column.cellBuilder(item)),
            ),
          ),
          if (actionBuilder != null)
            DataCell(SizedBox(width: actionWidth, child: actionBuilder!(item))),
        ],
      );
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final minWidth =
            columns.fold<double>(0, (sum, item) => sum + item.width) +
            (actionBuilder != null ? actionWidth : 0) +
            (columnSpacing * (allColumns.length - 1)) +
            (horizontalMargin * 2);

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: minWidth < constraints.maxWidth
                  ? constraints.maxWidth
                  : minWidth,
            ),
            child: DataTable(
              columnSpacing: columnSpacing,
              horizontalMargin: horizontalMargin,
              headingRowHeight: headingRowHeight,
              dataRowMinHeight: dataRowMinHeight,
              dataRowMaxHeight: dataRowMaxHeight,
              columns: allColumns,
              rows: allRows,
            ),
          ),
        );
      },
    );
  }
}
