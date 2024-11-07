import 'package:flutter/material.dart';
import '../user_preferences.dart';

class BmiTab extends StatefulWidget {
  @override
  _BmiTabState createState() => _BmiTabState();
}

class _BmiTabState extends State<BmiTab> {
   // User data variables
  double? _currentWeight;
  double? _height;
  double _bmi = 0.0;
  String _bmiCategory = '';
  List<Map<String, dynamic>> weightCategories = [] ;


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

List<Map<String, dynamic>> calculateWeightCategories(double heightCm) {
  double heightM = heightCm / 100; // Convert height to meters
  double heightSquared = heightM * heightM;

  // Calculate weight ranges for each BMI category
  return [
    {
      'category': 'Severe Thinness',
      'range': '< 16.0',
      'weight': '${(16.0 * heightSquared).toStringAsFixed(1)}',
      'color': Color(0xFF1C80D8),
    },
    {
      'category': 'Moderate Thinness',
      'range': '16.0 - 16.9',
      'weight': '${(16.0 * heightSquared).toStringAsFixed(1)} - ${(17.0 * heightSquared).toStringAsFixed(1)}',
      'color': Color(0xFF21A6F3),
    },
    {
      'category': 'Mild Thinness',
      'range': '17.0 - 18.4',
      'weight': '${(17.0 * heightSquared).toStringAsFixed(1)} - ${(18.5 * heightSquared).toStringAsFixed(1)}',
      'color': Color(0xFF00CCFF),
    },
    {
      'category': 'Normal',
      'range': '18.5 - 24.9',
      'weight': '${(18.5 * heightSquared).toStringAsFixed(1)} - ${(25.0 * heightSquared).toStringAsFixed(1)}',
      'color': Color(0xFF40BC64),
    },
    {
      'category': 'Overweight',
      'range': '25.0 - 29.9',
      'weight': '${(25.0 * heightSquared).toStringAsFixed(1)} - ${(30.0 * heightSquared).toStringAsFixed(1)}',
      'color': Color(0xFFFBBC00),
    },
    {
      'category': 'Obese Class I',
      'range': '30.0 - 34.9',
      'weight': '${(30.0 * heightSquared).toStringAsFixed(1)} - ${(35.0 * heightSquared).toStringAsFixed(1)}',
      'color': Color(0xFFFE9900),
    },
    {
      'category': 'Obese Class II',
      'range': '35.0 - 39.9',
      'weight': '${(35.0 * heightSquared).toStringAsFixed(1)} - ${(40.0 * heightSquared).toStringAsFixed(1)}',
      'color': Color(0xFFFD553A),
    },
    {
      'category': 'Obese Class III',
      'range': '≥ 40.0',
      'weight': '> ${(40.0 * heightSquared).toStringAsFixed(1)}',
      'color': Color(0xFFEA3C31),
    },
    // Add more categories if needed
  ];
}


Future<void> _loadUserData() async {
    final userPrefs = UserPreferences();
    setState(() {
      _currentWeight = userPrefs.currentWeight;
      _height = userPrefs.height;

    // Bmi calculation 
     if (_currentWeight != null && _height != null && _height! > 0) {
    double heightInMeters = _height! / 100; // Convert height to meters
    _bmi = _currentWeight! / (heightInMeters * heightInMeters); // Calculate BMI
    } else {
    _bmi = 0.0; // Handle cases where height or weight is not set
    }
  if (_bmi < 16.0) {
    _bmiCategory = 'Severe Thinness';
  } else if (_bmi >= 16.0 && _bmi < 17.0) {
    _bmiCategory = 'Moderate Thinness';
  } else if (_bmi >= 17.0 && _bmi < 18.5) {
    _bmiCategory = 'Mild Thinness';
  } else if (_bmi >= 18.5 && _bmi < 25.0) {
    _bmiCategory = 'Normal';
  } else if (_bmi >= 25.0 && _bmi < 30.0) {
    _bmiCategory = 'Overweight';
  } else if (_bmi >= 30.0 && _bmi < 35.0) {
    _bmiCategory = 'Obese Class I';
  } else if (_bmi >= 35.0 && _bmi < 40.0) {
    _bmiCategory = 'Obese Class II';
  } else if (_bmi >= 40.0) {
    _bmiCategory = 'Obese Class III';
  } else {
    _bmiCategory = 'Unknown';
  }

  double height = _height ?? 0.0; // Provide a default value if _height is null
   weightCategories = calculateWeightCategories(height);

  print(weightCategories[0]['category']);

    
    });
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // // Heading
            // Text(
            //   'Trends',
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 20),

            // // Trends Rows
            // _buildTrendRow('Last 7 Days Changes', '- 4.0 kg' ),
            // _buildTrendRow('Last 30 Days', '- 1.6 kg'),
            // _buildTrendRow('All Time High', '90.5 kg'),
            // _buildTrendRow('All Time Low', '88.5 kg'),
            // SizedBox(height: 20),

            // BMI Section
            Text(
              'BMI',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // BMI Rectangle
            _buildBmiRectangle(_bmiCategory, '${_bmi.toStringAsFixed(1)} kg/m²', Color(0xFFFBBC00)),
            SizedBox(height: 10),
            _buildBmiColorScale(),
            SizedBox(height: 20),

            // Weight Range
            _buildWeightRange('Normal Weight', '${weightCategories[3]['weight']} Kg'),
            SizedBox(height: 50),
           

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
        Text(value, style: TextStyle(color: Color(0xFF7F7A7A) ,fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // Function to build the BMI rectangle display
  Widget _buildBmiRectangle(String label, String bmiValue, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.white , fontWeight: FontWeight.bold)),
          Text(bmiValue, style: TextStyle(fontSize: 16, color: Colors.white , fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Function to build the BMI color scale rectangle
  Widget _buildBmiColorScale() {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
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
        Text(label, style: TextStyle(fontSize: 18 , color: Color(0xFF7D7D7D), fontWeight: FontWeight.w600 )),
        Text(value, style: TextStyle(fontSize: 18 , color: Color(0xFF7D7D7D), fontWeight: FontWeight.w600 )),
      ],
    );
  }

  // Function to build the weight difference row
  Widget _buildWeightDifference(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 18 , color: Color(0xFF7D7D7D), fontWeight: FontWeight.w600 )),
        Text(value, style: TextStyle(fontSize: 18 , color: Color(0xFF7D7D7D), fontWeight: FontWeight.w600 )),
      ],
    );
  }

 Widget _buildBmiTable() {
  return Table(
    columnWidths: {
      0: FlexColumnWidth(1.5), // Adjusts to take more space for "Category"
      1: FlexColumnWidth(0.8), // Adjusts width for "Statistics"
      2: FlexColumnWidth(1.0), // Adjusts width for "Weight"
    },
    children: [
      TableRow(
        children: [
          _buildTableHeaderCell('Category'),
          _buildTableHeaderCell('Statistics'),
          _buildTableHeaderCell('Weight'),
        ],
      ),
      // Dynamically generate rows based on the updated weightCategories
      for (var category in weightCategories)
        _buildBmiTableRow(
          category['category'], 
          category['range'],
          category['weight'], 
          category['color'], 
        ),
    ],
  );
}

  // Function to create header cells in the table
  Widget _buildTableHeaderCell(String title) {
    return Container(

      padding: EdgeInsets.all(8.0),
      height: 50.0, // Set the desired height here
      child:  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  // Function to create BMI table rows
 TableRow _buildBmiTableRow(String category, String statistics, String weightRange, Color color) {
  return TableRow(
    children: [
      _buildTableCellWithColor(category, color),
      _buildTableCell(statistics),
      _buildTableCell(weightRange),
    ],
  );
}

Widget _buildTableCellWithColor(String content, Color color) {
  return Container(
    height: 50.0, // Set the desired height here
    padding: EdgeInsets.all(8.0),
    child: Row(
      children: [
        Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(content),
          ),
        ),
      ],
    ),
  );
}


  // Function to create normal cells in the table
  Widget _buildTableCell(String content) {
    return Container(
      height: 50.0, // Set the desired height here
      padding: EdgeInsets.all(8.0),
      child: Text(content),
    );
  }
}
