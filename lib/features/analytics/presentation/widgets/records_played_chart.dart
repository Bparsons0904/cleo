// lib/features/analytics/presentation/widgets/records_played_chart.dart
import 'package:cleo/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RecordsPlayedChart extends StatelessWidget {
  final List<ChartData> data;

  const RecordsPlayedChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text('No data available for selected filters'),
      );
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, horizontalInterval: 1),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                // Show more labels based on data size
                int interval = data.length > 14 ? 4 : (data.length > 7 ? 2 : 1);

                if (value.toInt() % interval != 0 &&
                    value.toInt() != data.length - 1) {
                  return const SizedBox.shrink();
                }

                if (value.toInt() >= 0 && value.toInt() < data.length) {
                  final label = data[value.toInt()].label;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      label,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              data.length,
              (index) => FlSpot(index.toDouble(), data[index].count.toDouble()),
            ),
            isCurved: true,
            color: Colors.blue.shade300,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter:
                  (spot, percent, barData, index) => FlDotCirclePainter(
                    radius: 4,
                    color: Colors.blue,
                    strokeWidth: 1,
                    strokeColor: Colors.white,
                  ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.shade100.withOpacity(0.3),
            ),
          ),
        ],
        minY: 0,
      ),
    );
  }
}
