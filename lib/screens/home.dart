import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeTab extends StatelessWidget {
  final double startWeight = 90.0;
  final double currentWeight = 85.0;
  final double targetWeight = 75.0;
  final double weightChange = 5.0;

  double get remainingWeight => currentWeight - targetWeight;

  // List of dates corresponding to each x-axis value
  final List<String> dates = [
    "1/10/2024",
    "2/10/2024",
    "3/10/2024",
    "4/10/2024",
    "5/10/2024",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLabelWithIcon(Icons.flag, "Start", "$startWeight Kg"),
              _buildLabelWithIcon(Icons.monitor_weight, "Current", "$currentWeight Kg"),
              _buildLabelWithIcon(Icons.emoji_events, "Target", "$targetWeight Kg"),
            ],
          ),
          SizedBox(height: 20),

          // Adjusted Line Chart for Weight Progress
          SizedBox(
            height: 450,
            child: LineChart(
              LineChartData(
                minY: 65, // Set the minimum y-axis value to 65
                maxY: 100, // Set the maximum y-axis value to 100
                gridData: FlGridData(show: true , 
                drawHorizontalLine: true, // Draw horizontal lines
                  drawVerticalLine: false, // Do not draw vertical lines
                  ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      getTitlesWidget: (value, _) => Text(
                        value.toStringAsFixed(0),
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1, // Show labels at each data point
                      getTitlesWidget: (value, _) {
                        int index = value.toInt() - 1;
                        return Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                          index >= 0 && index < dates.length ? dates[index] : '',
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        )
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false), // Hide top titles
                  ),
                  rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false), // Hide right titles
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(1, 90),
                      FlSpot(2, 89),
                      FlSpot(3, 87),
                      FlSpot(4, 86),
                      FlSpot(5, 85),
                    ],
                    isCurved: true,
                    barWidth: 2,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeightColumn("Change", "$weightChange Kg"),
              IconButton(
                icon: Icon(Icons.add_circle, color: Colors.green, size: 100),
                onPressed: () {
                  // Add functionality here
                },
              ),
              _buildWeightColumn("Remaining", "$remainingWeight Kg"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabelWithIcon(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 30),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 16, color: Colors.black)),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }

  Widget _buildWeightColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.black)),
        SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }
}
