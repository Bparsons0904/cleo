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
        // Minimal grid with subtle lines
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 1,
              dashArray: [5, 5], // Dotted lines
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 1,
              dashArray: [5, 5], // Dotted lines
            );
          },
        ),
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
          border: Border.all(color: Colors.grey.shade100, width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              data.length,
              (index) => FlSpot(index.toDouble(), data[index].count.toDouble()),
            ),
            isCurved: true,
            color: Colors.blue.shade400,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter:
                  (spot, percent, barData, index) => FlDotCirclePainter(
                    radius: 5,
                    color: Colors.blue.shade400,
                    strokeWidth: 1,
                    strokeColor: Colors.white,
                  ),
            ),
            belowBarData: BarAreaData(
              show: false, // No background fill
            ),
          ),
        ],
        minY: 0,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                return LineTooltipItem(
                  '${data[index].label}: ${spot.y.toInt()} plays',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),
      ),
    );
  }
}
