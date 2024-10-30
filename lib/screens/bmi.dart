import 'package:flutter/material.dart';

class BmiTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Wrap the entire content in SingleChildScrollView
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Text(
              'Trends',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Trends Rows
            _buildTrendRow('Last 7 Days Changes', '- 4.0 kg'),
            _buildTrendRow('Last 30 Days', '- 1.6 kg'),
            _buildTrendRow('All Time High', '90.5 kg'),
            _buildTrendRow('All Time Low', '88.5 kg'),
            SizedBox(height: 20),

            // BMI Section
            Text(
              'BMI',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // BMI Rectangle
            _buildBmiRectangle('Overweight', '27.3 kg/m²', Color(0xFFFBBC00)),
            SizedBox(height: 10),
            _buildBmiColorScale(),
            SizedBox(height: 20),

            // Weight Range
            _buildWeightRange('Normal Weight', '60.2 - 81.3 kg'),
            SizedBox(height: 10),
            _buildWeightDifference('Difference', '5.4 kg'),
            SizedBox(height: 20),

            // BMI Categories Table
            _buildBmiTable(),
          ],
        ),
      ),
    );
  }

  // Function to build each trend row
  Widget _buildTrendRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Function to build the BMI rectangle display
  Widget _buildBmiRectangle(String label, String bmiValue, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 18)),
          Text(bmiValue, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  // Function to build the BMI color scale rectangle
  Widget _buildBmiColorScale() {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Color(0xFF1C80D8), // Severe Thinness
            Color(0xFF21A6F3), // Moderate Thinness
            Color(0xFF00CCFF), // Mild Thinness
            Color(0xFF40BC64), // Normal
            Color(0xFFFBBC00), // Overweight
            Color(0xFFFE9900), // Obese Class I
            Color(0xFFFD553A), // Obese Class II
            Color(0xFFEA3C31), // Obese Class III
          ],
          stops: [0.1, 0.25, 0.4, 0.55, 0.7, 0.85, 0.95, 1.0], // Adjust stops for each color section
        ),
      ),
    );
  }

  // Function to build the weight range row
  Widget _buildWeightRange(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Function to build the weight difference row
  Widget _buildWeightDifference(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Function to build the BMI categories table
  Widget _buildBmiTable() {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            _buildTableHeaderCell('Category'),
            _buildTableHeaderCell('Statistics'),
            _buildTableHeaderCell('Weight'),
          ],
        ),
        _buildBmiTableRow('Severe Thinness', '< 16.0', '52.0 kg', Color(0xFF1C80D8)),
        _buildBmiTableRow('Moderate Thinness', '16.0 - 16.9', '54.0 kg', Color(0xFF21A6F3)),
        _buildBmiTableRow('Mild Thinness', '17.0 - 18.4', '57.0 kg', Color(0xFF00CCFF)),
        _buildBmiTableRow('Normal', '18.5 - 24.9', '70.0 kg', Color(0xFF40BC64)),
        _buildBmiTableRow('Overweight', '25.0 - 29.9', '85.0 kg', Color(0xFFFBBC00)),
        _buildBmiTableRow('Obese Class I', '30.0 - 34.9', '95.0 kg', Color(0xFFFE9900)),
        _buildBmiTableRow('Obese Class II', '35.0 - 39.9', '105.0 kg', Color(0xFFFD553A)),
        _buildBmiTableRow('Obese Class III', '≥ 40.0', '120.0 kg', Color(0xFFEA3C31)),
        // Add more categories if needed
      ],
    );
  }

  // Function to create header cells in the table
  Widget _buildTableHeaderCell(String title) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.grey[300],
      child: Center(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold))),
    );
  }

  // Function to create BMI table rows
  TableRow _buildBmiTableRow(String category, String statistics, String weight, Color color) {
    return TableRow(
      children: [
        _buildTableCellWithColor(category, color),
        _buildTableCell(statistics),
        _buildTableCell(weight),
      ],
    );
  }

  // Function to create normal cells in the table with colored background
  Widget _buildTableCellWithColor(String content, Color color) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: color.withOpacity(0.2), // Lighten the color for better visibility
      child: Center(child: Text(content)),
    );
  }

  // Function to create normal cells in the table
  Widget _buildTableCell(String content) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Center(child: Text(content)),
    );
  }
}
