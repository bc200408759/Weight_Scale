import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import '../user_preferences.dart'; // Import your UserPreferences class

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<String> dates = [
    "1/10/2024",
    "2/10/2024",
    "3/10/2024",
    "4/10/2024",
    "5/10/2024",
  ];

  double startWeight = 0.0;
  double currentWeight = 0.0;
  double targetWeight = 0.0;
  double weightChange = 0.0;
  double remainingWeight = 0.0;

  final UserPreferences _userPreferences = UserPreferences();

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    await _userPreferences.init();

    setState(() {
      startWeight = _userPreferences.startWeight ?? 0.0;
      currentWeight = _userPreferences.currentWeight ?? 0.0;
      targetWeight = _userPreferences.targetWeight ?? 0.0;
      weightChange = startWeight - currentWeight;
      remainingWeight = currentWeight - targetWeight; 
    });
  }

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
              _buildLabelWithIcon('assets/start_flag.svg', 'Start', '$startWeight Kg'),
              _buildLabelWithIcon('assets/scale-weigh.svg', 'Current', '$currentWeight Kg'),
              _buildLabelWithIcon('assets/trophy.svg', 'Goal', '$targetWeight Kg'),
            ],
          ),
          SizedBox(height: 20),

          // Adjusted Line Chart for Weight Progress
          SizedBox(
            height: 450,
            child: LineChart(
              LineChartData(
                minY: 65,
                maxY: 100,
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
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
                      interval: 1,
                      getTitlesWidget: (value, _) {
                        int index = value.toInt() - 1;
                        return Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            index >= 0 && index < dates.length ? dates[index] : '',
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
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
                    color: Color(0xFF5DD75B),
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
                icon: Icon(Icons.add_circle, color: Color(0xFF5DD75B), size: 100),
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

  Widget _buildLabelWithIcon(String svgPath, String label, String value) {
    return Column(
      children: [
        SvgPicture.asset(
          svgPath,
          height: 30,
          width: 30,
        ),
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
