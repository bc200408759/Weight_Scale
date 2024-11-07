import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import '../user_preferences.dart'; // Import your UserPreferences class
import '../weight_history.dart'; // Import your WeightHistory class

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<String> dates = [];
  List<FlSpot> weightSpots = []; // Store FlSpot data for the chart

  double startWeight = 0.0;
  double currentWeight = 0.0;
  double targetWeight = 0.0;
  double weightChange = 0.0;
  double remainingWeight = 0.0;

  final UserPreferences _userPreferences = UserPreferences();
  final WeightHistory _weightHistory = WeightHistory();

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    _initializeWeightHistory();
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

  Future<void> _initializeWeightHistory() async {
    await _weightHistory.init();
    _loadWeightHistory();
  }

  void _loadWeightHistory() {
    final history = _weightHistory.getHistory();
    
    // Populate the FlSpot data and dates
    weightSpots = [];
    dates.clear(); // Clear previous dates

    for (var i = 0; i < history.length; i++) {
      final entry = history[i];
      weightSpots.add(FlSpot(i.toDouble() + 1, entry['weight'])); // FlSpot(x, y)
      dates.add(DateTime.parse(entry['date']).toLocal().day.toString());
    }

    setState(() {}); // Trigger a rebuild to update the chart
  }

  Future<void> _addWeightEntry() async {
    final double? weight = await _showWeightInputDialog();
    if (weight != null) {
      await _weightHistory.addWeightEntry(weight);

      // Update UserPreferences with the new current weight
      await _userPreferences.setCurrentWeight(weight); // Update current weight in UserPreferences

      // Update UI state
      setState(() {
        currentWeight = weight; // Update the currentWeight state variable
        weightChange = startWeight - currentWeight; // Recalculate weightChange
        remainingWeight = currentWeight - targetWeight; // Recalculate remainingWeight
      });

      _loadWeightHistory();  // Refresh weight history data
      _weightHistory.printWeightHistory();  // Print weight history to the console
    }
  }

  Future<double?> _showWeightInputDialog() async {
    double? weight;
    return await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        double inputWeight = 0.0;
        return AlertDialog(
          title: Text("Add Weight Entry"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter your weight (kg)"),
            onChanged: (value) {
              inputWeight = double.tryParse(value) ?? 0.0;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Add"),
              onPressed: () {
                Navigator.of(context).pop(inputWeight);
              },
            ),
          ],
        );
      },
    );
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

          // Updated Line Chart for Weight Progress
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
                    spots: weightSpots, // Use the FlSpot data from weight history
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
              _buildWeightColumn("Change", '${weightChange.toStringAsFixed(1)} Kg'),
              IconButton(
                icon: Icon(Icons.add_circle, color: Color(0xFF5DD75B), size: 100),
                onPressed: _addWeightEntry, // Call the function to add weight entry
              ),
              _buildWeightColumn("Remaining",'${remainingWeight.toStringAsFixed(1)} Kg'),
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
        Text(label, style: TextStyle(fontSize: 16, color: Colors.black , fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, color: Colors.grey , fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildWeightColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.black , fontWeight: FontWeight.bold )),
        SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 16, color: Colors.grey , fontWeight: FontWeight.bold)),
      ],
    );
  }
}
