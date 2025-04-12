// lib/features/analytics/presentation/widgets/listening_time_chart.dart
import 'package:cleo/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ListeningTimeChart extends StatelessWidget {
  final List<ChartData> data;

  const ListeningTimeChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text('No data available for selected filters'),
      );
    }

    // Completely rebuilt chart configuration
    return LineChart(
      LineChartData(
        // Minimal grid with subtle lines
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: 60,
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
        // Configure titles
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
                // Format as hours and minutes
                final hours = (value ~/ 60);
                final minutes = (value % 60).toInt();
                String label;

                if (hours > 0) {
                  label = '${hours}h';
                  if (minutes > 0) {
                    label += ' ${minutes}m';
                  }
                } else {
                  label = '${minutes}m';
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
        ),
        // Subtle border around chart area
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.shade100, width: 1),
        ),
        // Configure the line
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              data.length,
              (index) =>
                  FlSpot(index.toDouble(), data[index].duration.toDouble()),
            ),
            isCurved: true,
            color: Colors.teal,
            barWidth: 3,
            isStrokeCapRound: true,
            // Configure the dots
            dotData: FlDotData(
              show: true,
              getDotPainter:
                  (spot, percent, barData, index) => FlDotCirclePainter(
                    radius: 5,
                    color: Colors.teal,
                    strokeWidth: 1,
                    strokeColor: Colors.white,
                  ),
            ),
            // Completely disable any background filling or pattern
            belowBarData: BarAreaData(
              show: false, // This is the key change - no background fill at all
            ),
          ),
        ],
        // Start Y-axis at 0
        minY: 0,
        // Touch interaction settings
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                final minutes = spot.y.toInt();
                final hours = minutes ~/ 60;
                final remainingMinutes = minutes % 60;
                String timeText = '';

                if (hours > 0) {
                  timeText = '$hours hours';
                  if (remainingMinutes > 0) {
                    timeText += ' $remainingMinutes min';
                  }
                } else {
                  timeText = '$minutes min';
                }

                return LineTooltipItem(
                  '${data[index].label}: $timeText',
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
